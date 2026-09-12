import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/premium_introduction/components/lifetime_purchase_button.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class _FakeStoreProduct extends Fake implements StoreProduct {
  _FakeStoreProduct({required this.fakePriceString});
  final String fakePriceString;

  @override
  String get priceString => fakePriceString;
}

class _FakeLifetimePackage extends Fake implements Package {
  _FakeLifetimePackage({required this.fakePriceString});
  final String fakePriceString;

  @override
  StoreProduct get storeProduct => _FakeStoreProduct(fakePriceString: fakePriceString);

  @override
  PackageType get packageType => PackageType.lifetime;
}

void main() {
  group('#LifetimePurchaseButton', () {
    testWidgets('割引中で通常買い切り価格をストアから取得できている場合、割引バッジにストアの価格が表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LifetimePurchaseButton(
              lifetimePackage: _FakeLifetimePackage(fakePriceString: '¥10,000'),
              lifetimePremiumPackage: _FakeLifetimePackage(fakePriceString: '¥15,000'),
              discountRate: 30,
              offeringType: OfferingType.discount,
              onTap: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('通常買い切り価格の ¥15,000 よりも 30％OFF'), findsOneWidget);
    });

    testWidgets('割引中でも通常買い切り価格をストアから取得できない場合、割引バッジ自体を表示しない', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LifetimePurchaseButton(
              lifetimePackage: _FakeLifetimePackage(fakePriceString: '¥10,000'),
              lifetimePremiumPackage: null,
              discountRate: 30,
              offeringType: OfferingType.discount,
              onTap: (_) {},
            ),
          ),
        ),
      );

      expect(find.textContaining('通常買い切り価格'), findsNothing);
      expect(find.textContaining('％OFF'), findsNothing);
    });

    testWidgets('割引提供ではない場合、割引バッジを表示しない', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LifetimePurchaseButton(
              lifetimePackage: _FakeLifetimePackage(fakePriceString: '¥10,000'),
              lifetimePremiumPackage: _FakeLifetimePackage(fakePriceString: '¥15,000'),
              discountRate: 30,
              offeringType: OfferingType.premium,
              onTap: (_) {},
            ),
          ),
        ),
      );

      expect(find.textContaining('通常買い切り価格'), findsNothing);
    });
  });
}
