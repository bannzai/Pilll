import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/features/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/fake.dart';

class _FakeOfferings extends Fake implements Offerings {}

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#offeringType", () {
    test("when hasDiscountEntitlement = false should return premium", () async {
      final n = now();
      final user = User(discountEntitlementDeadlineDate: n);
      final container = ProviderContainer(
        overrides: [
          customerInfoProviderOverride(freeCustomerInfo),
          remoteConfigParameterProvider
              .overrideWithValue(RemoteConfigParameter()),
          isOverDiscountDeadlineProvider(
            discountEntitlementDeadlineDate: n,
          ).overrideWithValue(false),
          purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
        ],
      );
      final currentOfferingType = container.read(
        currentOfferingTypeProvider(user),
      );
      expect(currentOfferingType, equals(OfferingType.premium));
    });
    test("when isOverDiscountDeadline = true should return premium", () async {
      final n = now();
      final user = User(discountEntitlementDeadlineDate: n);
      final container = ProviderContainer(
        overrides: [
          customerInfoProviderOverride(freeCustomerInfo),
          remoteConfigParameterProvider
              .overrideWithValue(RemoteConfigParameter()),
          isOverDiscountDeadlineProvider(
            discountEntitlementDeadlineDate: n,
          ).overrideWithValue(true),
          purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
        ],
      );
      final currentOfferingType = container.read(
        currentOfferingTypeProvider(user),
      );
      expect(currentOfferingType, equals(OfferingType.premium));
    });
    test("should return limited", () async {
      // 割引の期限内 (割引の権限がある) の状態を作るため、期限を今より後にする
      final discountEntitlementDeadlineDate =
          now().add(const Duration(days: 1));
      final user =
          User(discountEntitlementDeadlineDate: discountEntitlementDeadlineDate);
      final container = ProviderContainer(
        overrides: [
          customerInfoProviderOverride(freeCustomerInfo),
          remoteConfigParameterProvider
              .overrideWithValue(RemoteConfigParameter()),
          isOverDiscountDeadlineProvider(
            discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
          ).overrideWithValue(false),
          purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
        ],
      );
      final currentOfferingType = container.read(
        currentOfferingTypeProvider(user),
      );
      expect(currentOfferingType, equals(OfferingType.discount));
    });
  });
}
