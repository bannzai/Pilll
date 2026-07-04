import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/tick.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class FakeUser extends Mock implements User {
  FakeUser({
    // ignore: unused_element
    this.fakeIsPremium = false,
    // ignore: unused_element
    this.fakeIsTrial = false,
    // ignore: unused_element
    this.fakeTrialDeadlineDate,
    // ignore: unused_element
    this.fakeDiscountEntitlementDeadlineDate,
    // ignore: unused_element
    this.fakeIsExpiredDiscountEntitlements = false,
  });
  final DateTime? fakeTrialDeadlineDate;
  final DateTime? fakeDiscountEntitlementDeadlineDate;
  final bool fakeIsPremium;
  final bool fakeIsTrial;
  final bool fakeIsExpiredDiscountEntitlements;

  @override
  bool get isPremium => fakeIsPremium;
  @override
  bool get isTrial => fakeIsTrial;
  @override
  bool get hasDiscountEntitlement => fakeIsExpiredDiscountEntitlements;
  @override
  DateTime? get trialDeadlineDate => fakeTrialDeadlineDate;
  @override
  DateTime? get discountEntitlementDeadlineDate =>
      fakeDiscountEntitlementDeadlineDate;

  @override
  bool get premiumOrTrial => isPremium || isTrial;
}

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
