import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/purchase.dart';

void main() {
  group('#hasPurchasedAnyProductProvider', () {
    // purchases_flutter の plugin の Dart 側が使う MethodChannel
    const purchasesChannel = MethodChannel('purchases_flutter');

    Future<bool> readHasPurchasedAnyProduct(
        {required List<String> allPurchasedProductIdentifiers}) async {
      TestWidgetsFlutterBinding.ensureInitialized();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        purchasesChannel,
        (call) async => call.method == 'getCustomerInfo'
            ? {
                'entitlements': {'all': {}, 'active': {}},
                'allPurchaseDates': {},
                'activeSubscriptions': [],
                'allPurchasedProductIdentifiers':
                    allPurchasedProductIdentifiers,
                'nonSubscriptionTransactions': [],
                'firstSeen': '',
                'originalAppUserId': '',
                'allExpirationDates': {},
                'requestDate': '',
              }
            : null,
      );
      addTearDown(() => TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger
          .setMockMethodCallHandler(purchasesChannel, null));
      final container = ProviderContainer();
      addTearDown(container.dispose);
      return container.read(hasPurchasedAnyProductProvider.future);
    }

    test('課金の商品の購入履歴があればtrue', () async {
      expect(
          await readHasPurchasedAnyProduct(
              allPurchasedProductIdentifiers: ['premium_monthly']),
          isTrue);
    });

    test('トライアル (Promotional Entitlement) の履歴だけならfalse', () async {
      expect(
          await readHasPurchasedAnyProduct(
              allPurchasedProductIdentifiers: ['rc_promo_Premium_custom']),
          isFalse);
    });

    test('トライアルの後に課金した履歴があればtrue', () async {
      expect(
          await readHasPurchasedAnyProduct(allPurchasedProductIdentifiers: [
            'rc_promo_Premium_custom',
            'premium_monthly'
          ]),
          isTrue);
    });

    test('購入履歴が無ければfalse', () async {
      expect(
          await readHasPurchasedAnyProduct(allPurchasedProductIdentifiers: []),
          isFalse);
    });
  });
}
