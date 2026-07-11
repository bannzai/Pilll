import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/lifetime_offer/lifetime_offer_plan.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/provider/tick.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:pilll/utils/shared_preference/keys.dart';

/// Pilll利用開始日からの経過日数を返すProvider
///
/// 利用開始日は firebaseAuthUser.metadata.creationTime（匿名サインイン時刻＝実質初回起動日）を使用する。
/// FirebaseAuthのユーザー情報が取得できるまではnullを返す。
final lifetimeOfferUsageDaysProvider = Provider.autoDispose<int?>((ref) {
  final userBeginDate = ref.watch(firebaseUserStateProvider).valueOrNull?.metadata.creationTime;
  if (userBeginDate == null) {
    return null;
  }
  return daysBetween(userBeginDate, today());
});

/// 買い切りオファーの表示周期の日数。1年ごとに同じ時期へオファーを出すための固定値（うるう年による1日程度のずれは許容する）
const _lifetimeOfferCycleDays = 365;

/// 月額300円オファーを優先する利用日数。3年を365日/年として判定する。
const monthly300OfferUsageDaysSince = _lifetimeOfferCycleDays * 3;

/// 無料かつ3年以上の利用者にはDiscount offeringの月額プランを優先する。
final lifetimeOfferPlanProvider = Provider.autoDispose<LifetimeOfferPlan?>((ref) {
  final user = ref.watch(userProvider).valueOrNull;
  final usageDays = ref.watch(lifetimeOfferUsageDaysProvider);
  if (usageDays == null) {
    return null;
  }
  // 3年以上はユーザーの課金状態が確定するまで待ち、月額オファーより先に買い切りを表示しない。
  if (usageDays >= monthly300OfferUsageDaysSince && user == null) {
    return null;
  }
  if (user != null && !user.isPremium && usageDays >= monthly300OfferUsageDaysSince && ref.watch(monthlyDiscountPackageProvider) != null) {
    return LifetimeOfferPlan.monthly300;
  }
  return LifetimeOfferPlan.lifetime;
});

/// 買い切りオファーの周期番号（利用開始からの経過年数, 0始まり）を返すProvider
///
/// 初回表示時刻・起動時自動モーダルの表示済みフラグを周期ごとに持つためのキーに使う。
/// FirebaseAuthのユーザー情報が取得できるまではnullを返す。
final lifetimeOfferCycleProvider = Provider.autoDispose<int?>((ref) {
  final usageDays = ref.watch(lifetimeOfferUsageDaysProvider);
  if (usageDays == null) {
    return null;
  }
  return usageDays ~/ _lifetimeOfferCycleDays;
});

/// 周期ごとの初回表示時刻のSharedPreferencesキー
String lifetimeOfferFirstDisplayedDateTimeKey({required int cycle}) => '${StringKey.lifetimeOfferFirstDisplayedDateTime}_$cycle';

/// 周期ごとの起動時自動モーダル表示済みフラグのSharedPreferencesキー
String lifetimeOfferAutoModalShownKey({required int cycle}) => '${BoolKey.lifetimeOfferAutoModalShown}_$cycle';

/// 買い切りオファー（お知らせバー・起動時自動モーダル）を表示するかどうかを返すProvider
///
/// 利用開始から1年ごと、年会費の更新が近づく約1ヶ月前の時期に、割引版の買い切りプランを期間限定で訴求するための表示条件。
/// 課金・非課金を問わず全ユーザーが対象。ただし以下の場合は表示しない。
/// - Remote Configの lifetimeOfferEnabled が無効
/// - その周期の初回表示から lifetimeOfferDurationHours 時間の表示期限を過ぎた
/// - 買い切り購入済み（購入状態のロード中・エラー時も誤表示を避けるため非表示）
/// - Discount offeringのlifetime packageが取得できない（買い切りはiOSのみ実装のためAndroidは常に非表示）
/// - 365日周期に換算した利用日数が lifetimeOfferUserCreationDaysSince < n < lifetimeOfferUserCreationDaysUntil の排他境界の範囲外
///   （上限は1年の年会費更新と重なる課金トラブルを避けるため、更新直前を除外する意図で設定されている）
final shouldShowLifetimeOfferProvider = Provider.autoDispose<bool>((ref) {
  final remoteConfigParameter = ref.watch(remoteConfigParameterProvider);
  if (!remoteConfigParameter.lifetimeOfferEnabled) {
    return false;
  }
  if (ref.watch(isOverLifetimeOfferDeadlineProvider)) {
    return false;
  }
  if (ref.watch(isLifetimePurchasedProvider).valueOrNull != false) {
    return false;
  }
  final offerPlan = ref.watch(lifetimeOfferPlanProvider);
  final offerPackageExists = switch (offerPlan) {
    LifetimeOfferPlan.lifetime => ref.watch(lifetimeDiscountPackageProvider) != null,
    LifetimeOfferPlan.monthly300 => ref.watch(monthlyDiscountPackageProvider) != null,
    null => false,
  };
  if (!offerPackageExists) {
    return false;
  }
  final usageDays = ref.watch(lifetimeOfferUsageDaysProvider);
  if (usageDays == null) {
    return false;
  }
  // 1年ごとに同じ時期へオファーを出すため、周期内の日数で判定する
  final usageDaysInCycle = usageDays % _lifetimeOfferCycleDays;
  return usageDaysInCycle > remoteConfigParameter.lifetimeOfferUserCreationDaysSince &&
      usageDaysInCycle < remoteConfigParameter.lifetimeOfferUserCreationDaysUntil;
});

/// 買い切りオファーの表示期限を返すProvider
///
/// その周期の初回表示時刻からRemote Configの lifetimeOfferDurationHours 時間後を期限とする。
/// 初回表示時刻は周期ごとに持つため、周期が変わる（翌年になる）と新しい表示期限が始まる。
/// その周期でまだ表示していない（未セット）場合は期限が決まっていないためnullを返す。
final lifetimeOfferDeadlineProvider = Provider.autoDispose<DateTime?>((ref) {
  final cycle = ref.watch(lifetimeOfferCycleProvider);
  if (cycle == null) {
    return null;
  }
  final firstDisplayedDateTime = ref.watch(stringSharedPreferencesProvider(lifetimeOfferFirstDisplayedDateTimeKey(cycle: cycle))).value;
  if (firstDisplayedDateTime == null) {
    return null;
  }
  return DateTime.parse(firstDisplayedDateTime).add(Duration(hours: ref.watch(remoteConfigParameterProvider).lifetimeOfferDurationHours));
});

/// 買い切りオファーの表示期限を過ぎたかどうかを返すProvider
///
/// tickProviderにより毎秒再評価されるが、依存元へ通知されるのは値が変わる（false→true）瞬間だけなので、
/// shouldShowLifetimeOfferProvider の毎秒再評価は起きない。初回表示前（期限未確定）はfalseを返す。
final isOverLifetimeOfferDeadlineProvider = Provider.autoDispose<bool>((ref) {
  final deadline = ref.watch(lifetimeOfferDeadlineProvider);
  if (deadline == null) {
    return false;
  }
  return ref.watch(tickProvider).isAfter(deadline);
});

/// 買い切りオファーの表示期限までの残り時間を返すProvider
///
/// tickProviderを直接watchして毎秒値が変わるため、カウントダウン表示を毎秒更新したいWidget内でのみwatchする。
/// 初回表示前（期限未確定）は満額の残り時間として扱う。
final lifetimeOfferRemainingDurationProvider = Provider.autoDispose<Duration>((ref) {
  final deadline = ref.watch(lifetimeOfferDeadlineProvider);
  if (deadline == null) {
    return Duration(hours: ref.watch(remoteConfigParameterProvider).lifetimeOfferDurationHours);
  }
  return deadline.difference(ref.watch(tickProvider));
});

/// 買い切りオファーがその周期で初めて画面に表示された時刻を永続化する
///
/// お知らせバー・起動時自動モーダルのどちらが先に表示されても同じ時刻を起点に表示期限を計算できるよう、
/// 未セットの場合のみセットする（set-if-absentで冪等）。周期番号が確定していない場合は何もしない。
Future<void> setLifetimeOfferFirstDisplayedDateTimeIfAbsent(WidgetRef ref) async {
  final cycle = ref.read(lifetimeOfferCycleProvider);
  if (cycle == null) {
    return;
  }
  final key = lifetimeOfferFirstDisplayedDateTimeKey(cycle: cycle);
  if (ref.read(stringSharedPreferencesProvider(key)).value == null) {
    await ref.read(stringSharedPreferencesProvider(key).notifier).set(now().toIso8601String());
  }
}

/// 表示期限までの残り時間をHH:MM:SS形式の文字列にする
String lifetimeOfferCountdownString(Duration duration) {
  return DateTimeFormatter.clock(duration.inHours, duration.inMinutes % 60, duration.inSeconds % 60);
}
