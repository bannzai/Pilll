import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/provider/tick.dart';
import 'package:pilll/provider/typed_shared_preferences.dart';
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

/// 買い切りオファー（お知らせバー・起動時自動モーダル）を表示するかどうかを返すProvider
///
/// 利用開始から約1年になる約1ヶ月前のユーザーに、割引版の買い切りプランを期間限定で訴求するための表示条件。
/// 課金・非課金を問わず全ユーザーが対象。ただし以下の場合は表示しない。
/// - Remote Configの lifetimeOfferEnabled が無効
/// - 初回表示から lifetimeOfferDurationHours 時間の表示期限を過ぎた
/// - 買い切り購入済み（購入状態のロード中・エラー時も誤表示を避けるため非表示）
/// - Discount offeringのlifetime packageが取得できない（買い切りはiOSのみ実装のためAndroidは常に非表示）
/// - 利用日数が lifetimeOfferUserCreationDaysSince < n < lifetimeOfferUserCreationDaysUntil の排他境界の範囲外
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
  if (ref.watch(lifetimeDiscountPackageProvider) == null) {
    return false;
  }
  final usageDays = ref.watch(lifetimeOfferUsageDaysProvider);
  if (usageDays == null) {
    return false;
  }
  return usageDays > remoteConfigParameter.lifetimeOfferUserCreationDaysSince && usageDays < remoteConfigParameter.lifetimeOfferUserCreationDaysUntil;
});

/// 買い切りオファーの表示期限を返すProvider
///
/// 初回表示時刻（StringKey.lifetimeOfferFirstDisplayedDateTime）からRemote Configの
/// lifetimeOfferDurationHours 時間後を期限とする。初回表示前（未セット）は期限が決まっていないためnullを返す。
final lifetimeOfferDeadlineProvider = Provider.autoDispose<DateTime?>((ref) {
  final firstDisplayedDateTime = ref.watch(stringSharedPreferencesProvider(StringKey.lifetimeOfferFirstDisplayedDateTime)).value;
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

/// 買い切りオファーが初めて画面に表示された時刻を永続化する
///
/// お知らせバー・起動時自動モーダルのどちらが先に表示されても同じ時刻を起点に表示期限を計算できるよう、
/// 未セットの場合のみセットする（set-if-absentで冪等）。
Future<void> setLifetimeOfferFirstDisplayedDateTimeIfAbsent(WidgetRef ref) async {
  if (ref.read(stringSharedPreferencesProvider(StringKey.lifetimeOfferFirstDisplayedDateTime)).value == null) {
    await ref.read(stringSharedPreferencesProvider(StringKey.lifetimeOfferFirstDisplayedDateTime).notifier).set(now().toIso8601String());
  }
}

/// 表示期限までの残り時間をHH:MM:SS形式の文字列にする
String lifetimeOfferCountdownString(Duration duration) {
  return DateTimeFormatter.clock(duration.inHours, duration.inMinutes % 60, duration.inSeconds % 60);
}
