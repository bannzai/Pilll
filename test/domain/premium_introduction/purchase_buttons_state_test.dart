import 'package:pilll/analytics.dart';
import 'package:pilll/domain/premium_introduction/components/purchase_buttons_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
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
    test("when isExpiredDiscountEntitlements = true should return premium",
        () async {
      final state = PurchaseButtonsState(
        offerings: _FakeOfferings(),
        trialDeadlineDate: DateTime.now(),
        isExpiredDiscountEntitlements: true,
        isOverDiscountDeadline: false,
      );
      expect(state.offeringType, equals(OfferingType.premium));
    });
    test("when trialDeadlineDate is null should return premium", () async {
      final state = PurchaseButtonsState(
        offerings: _FakeOfferings(),
        trialDeadlineDate: null,
        isExpiredDiscountEntitlements: false,
        isOverDiscountDeadline: false,
      );
      expect(state.offeringType, equals(OfferingType.premium));
    });
    test("when isOverDiscountDeadline is null should return premium", () async {
      final state = PurchaseButtonsState(
        offerings: _FakeOfferings(),
        trialDeadlineDate: DateTime.now(),
        isExpiredDiscountEntitlements: false,
        isOverDiscountDeadline: null,
      );
      expect(state.offeringType, equals(OfferingType.premium));
    });
    test("when isOverDiscountDeadline = true should return premium", () async {
      final state = PurchaseButtonsState(
        offerings: _FakeOfferings(),
        trialDeadlineDate: DateTime.now(),
        isExpiredDiscountEntitlements: false,
        isOverDiscountDeadline: true,
      );
      expect(state.offeringType, equals(OfferingType.premium));
    });
    test("should return limited", () async {
      final state = PurchaseButtonsState(
        offerings: _FakeOfferings(),
        trialDeadlineDate: DateTime.now(),
        isExpiredDiscountEntitlements: false,
        isOverDiscountDeadline: false,
      );
      expect(state.offeringType, equals(OfferingType.limited));
    });
  });
}
