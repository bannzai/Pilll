import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

class _FakeOfferings extends Fake implements Offerings {}

class _FakePremiumAndTrial extends Fake implements PremiumAndTrial {
  _FakePremiumAndTrial({
    required this.fakeHasDiscountEntitlement,
    required this.fakeDiscountEntitlementDeadlineDate,
  });
  final bool fakeHasDiscountEntitlement;
  final DateTime? fakeDiscountEntitlementDeadlineDate;

  @override
  bool get hasDiscountEntitlement => fakeHasDiscountEntitlement;

  @override
  DateTime? get discountEntitlementDeadlineDate => fakeDiscountEntitlementDeadlineDate;
}

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    analytics = MockAnalytics();
  });
  group("#offeringType", () {
    test("when hasDiscountEntitlement = false should return premium", () async {
      final n = now();
      final premiumAndTrial = _FakePremiumAndTrial(
        fakeHasDiscountEntitlement: false,
        fakeDiscountEntitlementDeadlineDate: n,
      );
      final container = ProviderContainer(
        overrides: [
          isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate: n).overrideWithValue(false),
          purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
        ],
      );
      final currentOfferingType = container.read(currentOfferingTypeProvider(premiumAndTrial));
      expect(currentOfferingType, equals(OfferingType.premium));
    });
    test("when isOverDiscountDeadline = true should return premium", () async {
      final n = now();
      final premiumAndTrial = _FakePremiumAndTrial(
        fakeHasDiscountEntitlement: false,
        fakeDiscountEntitlementDeadlineDate: n,
      );
      final container = ProviderContainer(
        overrides: [
          isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate: n).overrideWithValue(true),
          purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
        ],
      );
      final currentOfferingType = container.read(currentOfferingTypeProvider(premiumAndTrial));
      expect(currentOfferingType, equals(OfferingType.premium));
    });
    test("should return limited", () async {
      final n = now();
      final premiumAndTrial = _FakePremiumAndTrial(
        fakeHasDiscountEntitlement: true,
        fakeDiscountEntitlementDeadlineDate: n,
      );
      final container = ProviderContainer(
        overrides: [
          isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate: n).overrideWithValue(false),
          purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
        ],
      );
      final currentOfferingType = container.read(currentOfferingTypeProvider(premiumAndTrial));
      expect(currentOfferingType, equals(OfferingType.limited));
    });
  });
}
