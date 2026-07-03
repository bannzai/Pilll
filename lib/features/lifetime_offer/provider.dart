import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/utils/datetime/day.dart';

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
/// 利用開始から約1年になる約1ヶ月前のユーザーに、割引版の買い切りプランを一度だけ訴求するための表示条件。
/// 課金・非課金を問わず全ユーザーが対象。ただし以下の場合は表示しない。
/// - Remote Configの lifetimeOfferEnabled が無効
/// - 買い切り購入済み（購入状態のロード中・エラー時も誤表示を避けるため非表示）
/// - Discount offeringのlifetime packageが取得できない（買い切りはiOSのみ実装のためAndroidは常に非表示）
/// - 利用日数が lifetimeOfferUserCreationDaysSince < n < lifetimeOfferUserCreationDaysUntil の排他境界の範囲外
///   （上限は1年の年会費更新と重なる課金トラブルを避けるため、更新直前を除外する意図で設定されている）
final shouldShowLifetimeOfferProvider = Provider.autoDispose<bool>((ref) {
  final remoteConfigParameter = ref.watch(remoteConfigParameterProvider);
  if (!remoteConfigParameter.lifetimeOfferEnabled) {
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
