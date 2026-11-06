import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:mockito/mockito.dart';
import 'package:pilll/provider/customer_info.dart';
import 'package:pilll/provider/tick.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod/riverpod.dart';

/// テスト用の RevenueCat の CustomerInfo を作る。
/// [activePremiumProductIdentifier] を渡すと、その商品で有効な Premium entitlement を持つ。
/// entitlement の期限は、SDK と同じく [allExpirationDates] のその商品の期限にする (無ければ期限なし)
CustomerInfo fakeCustomerInfo({
  List<String> activeSubscriptions = const [],
  Map<String, String?> allExpirationDates = const {},
  String? activePremiumProductIdentifier,
}) {
  final premiumEntitlements = {
    if (activePremiumProductIdentifier != null)
      'Premium': EntitlementInfo(
        'Premium',
        true,
        true,
        '',
        '',
        activePremiumProductIdentifier,
        false,
        expirationDate: allExpirationDates[activePremiumProductIdentifier],
      ),
  };
  return CustomerInfo(
    EntitlementInfos(premiumEntitlements, premiumEntitlements),
    const {},
    activeSubscriptions,
    const [],
    const [],
    '',
    '',
    allExpirationDates,
    '',
  );
}

/// 月額のサブスクリプションを購読中 (課金中) のユーザーの CustomerInfo。商品 ID は判定に使わないため実在しない値でよい
final premiumCustomerInfo = fakeCustomerInfo(
  activeSubscriptions: ['fake_premium_monthly'],
  activePremiumProductIdentifier: 'fake_premium_monthly',
);

/// 課金もトライアル (Promotional Entitlement) も無いユーザーの CustomerInfo
final freeCustomerInfo = fakeCustomerInfo();

/// トライアル (Promotional Entitlement) を [trialDeadlineDate] まで付与されたユーザーの CustomerInfo
CustomerInfo trialCustomerInfo({required DateTime trialDeadlineDate}) =>
    fakeCustomerInfo(
      activeSubscriptions:
          trialDeadlineDate.isAfter(now()) ? ['rc_promo_Premium_custom'] : [],
      allExpirationDates: {
        'rc_promo_Premium_custom': trialDeadlineDate.toUtc().toIso8601String()
      },
      activePremiumProductIdentifier:
          trialDeadlineDate.isAfter(now()) ? 'rc_promo_Premium_custom' : null,
    );

/// customerInfoProvider を最初のフレームから [customerInfo] を持つ状態にする override。
/// 画面は UserSetup が CustomerInfo の取得後にだけ表示され requireValue で読むため、読み込み中の状態を経由させない
Override customerInfoProviderOverride(CustomerInfo customerInfo) =>
    customerInfoProvider.overrideWith(
        () => FixedCustomerInfoNotifier(customerInfo: customerInfo));

class FakeAnalytics extends Fake implements Analytics {
  @override
  void logEvent({required String name, Map<String, dynamic>? parameters}) {}

  @override
  void logScreenView({
    required String screenName,
    String screenClass = 'Flutter',
  }) {}

  @override
  void setUserProperties(String name, value) {}
}

class FakeErrorLogger extends Fake implements ErrorLogger {
  @override
  void log(String message) {}

  @override
  void recordError(exception, StackTrace? stack) {}
}

class FakeRevenueCatPackage extends Fake implements Package {
  @override
  StoreProduct get storeProduct => FakeStoreProduct();
}

class FakeStoreProduct extends Fake implements StoreProduct {
  @override
  double get price => Random().nextDouble();

  @override
  String get priceString => '';
}

/// firebaseAuthUser.metadata.creationTime（利用開始日）を差し替えるためのFake
class FakeFirebaseAuthUser extends Fake implements firebase_auth.User {
  FakeFirebaseAuthUser({required this.fakeCreationTime});
  final DateTime? fakeCreationTime;

  @override
  firebase_auth.UserMetadata get metadata =>
      FakeUserMetadata(fakeCreationTime: fakeCreationTime);
}

/// creationTimeのみを返すUserMetadataのFake
class FakeUserMetadata extends Fake implements firebase_auth.UserMetadata {
  FakeUserMetadata({required this.fakeCreationTime});
  final DateTime? fakeCreationTime;

  @override
  DateTime? get creationTime => fakeCreationTime;
}

/// tickProviderのFake。Timerを作らず固定時刻を返し続ける
///
/// 本物のTickはTimer.periodicを作るため、testWidgetsでは
/// テスト終了時にpending timerとして失敗する。それを避けるために使う
class FakeTick extends Tick {
  FakeTick({required this.fakeDateTime});
  final DateTime fakeDateTime;

  @override
  DateTime build() => fakeDateTime;
}
