import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

class _FakeOfferings extends Fake implements Offerings {}

class _FakePremiumAndTrial extends Fake implements PremiumAndTrial {
  _FakePremiumAndTrial({
    required this.fakeHasDiscountEntitlement,
  });
  final bool fakeHasDiscountEntitlement;

  @override
  bool get hasDiscountEntitlement => fakeHasDiscountEntitlement;

  @override
  DateTime? get discountEntitlementDeadlineDate => null; // any value
}

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    analytics = MockAnalytics();
  });
  group("#offeringType", () {
    test("when hasDiscountEntitlement = false should return premium", () async {
      final premiumAndTrial = _FakePremiumAndTrial(
        fakeHasDiscountEntitlement: false,
      );
      final container = ProviderContainer(
        overrides: [
          isOverDiscountDeadlineProvider.overrideWith((ref, arg) => false),
          purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
        ],
      );
      final currentOfferingType = container.read(currentOfferingTypeProvider(premiumAndTrial));
      expect(currentOfferingType, equals(OfferingType.premium));
    });
    test("when isOverDiscountDeadline = true should return premium", () async {
      final premiumAndTrial = _FakePremiumAndTrial(
        fakeHasDiscountEntitlement: false,
      );
      final container = ProviderContainer(
        overrides: [
          isOverDiscountDeadlineProvider.overrideWith((ref, arg) => true),
          purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
        ],
      );
      final currentOfferingType = container.read(currentOfferingTypeProvider(premiumAndTrial));
      expect(currentOfferingType, equals(OfferingType.premium));
    });
    test("should return limited", () async {
      final premiumAndTrial = _FakePremiumAndTrial(
        fakeHasDiscountEntitlement: true,
      );
      final container = ProviderContainer(
        overrides: [
          isOverDiscountDeadlineProvider.overrideWith((ref, arg) => false),
          purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
        ],
      );
      final currentOfferingType = container.read(currentOfferingTypeProvider(premiumAndTrial));
      expect(currentOfferingType, equals(OfferingType.limited));
    });
  });
}
