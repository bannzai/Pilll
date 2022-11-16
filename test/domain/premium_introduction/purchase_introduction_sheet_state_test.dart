import 'package:pilll/analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

class _FakeOfferings extends Fake implements Offerings {}

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    analytics = MockAnalytics();
  });
  group("#offeringType", () {
    test("when hasDiscountEntitlement = false should return premium", () async {
      final state = PremiumIntroductionState(
        offerings: _FakeOfferings(),
        hasDiscountEntitlement: false,
        isOverDiscountDeadline: false,
      );
      expect(state.currentOfferingType, equals(OfferingType.premium));
    });
    test("when isOverDiscountDeadline = true should return premium", () async {
      final state = PremiumIntroductionState(
        offerings: _FakeOfferings(),
        hasDiscountEntitlement: true,
        isOverDiscountDeadline: true,
      );
      expect(state.currentOfferingType, equals(OfferingType.premium));
    });
    test("should return limited", () async {
      final state = PremiumIntroductionState(
        offerings: _FakeOfferings(),
        hasDiscountEntitlement: true,
        isOverDiscountDeadline: false,
      );
      expect(state.currentOfferingType, equals(OfferingType.limited));
    });
  });
}
