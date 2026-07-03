import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/lifetime_offer/page.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../helper/fake.dart';
import '../../helper/mock.mocks.dart';

class _LifetimeFakeProduct extends Fake implements StoreProduct {
  @override
  String get priceString => '';
  @override
  double get price => 12000;
}

class _LifetimeFakePackage extends Fake implements Package {
  @override
  StoreProduct get storeProduct => _LifetimeFakeProduct();
  @override
  PackageType get packageType => PackageType.lifetime;
}

void main() {
  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    TestWidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
    for (var element in RendererBinding.instance.renderViews) {
      element.configuration = TestViewConfiguration.fromView(
        view: WidgetsBinding.instance.platformDispatcher.views.single,
        size: const Size(414.0, 896.0),
      );
    }
  });

  group('#LifetimeOfferPageBody', () {
    Future<void> pumpLifetimeOfferPageBody(
      WidgetTester tester, {
      required User user,
      bool isLifetimePurchased = false,
      bool hasLifetimeDiscountPackage = true,
    }) async {
      final mockTodayRepository = MockTodayService();
      when(mockTodayRepository.now()).thenReturn(DateTime(2026, 7, 3));
      todayRepository = mockTodayRepository;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            lifetimeDiscountPackageProvider.overrideWith(
              (ref) =>
                  hasLifetimeDiscountPackage ? _LifetimeFakePackage() : null,
            ),
            lifetimePremiumPackageProvider.overrideWith(
              (ref) => _LifetimeFakePackage(),
            ),
            lifetimeDiscountRateProvider.overrideWith((ref) => 40.0),
            isLifetimePurchasedProvider.overrideWith(
              (ref) => Future.value(isLifetimePurchased),
            ),
            firebaseUserStateProvider.overrideWith(
              (ref) => Stream.value(
                FakeFirebaseAuthUser(
                  fakeCreationTime:
                      DateTime(2026, 7, 3).subtract(const Duration(days: 340)),
                ),
              ),
            ),
          ],
          child: MaterialApp(
            home: Material(
              child: LifetimeOfferPageBody(
                user: user,
                lifetimeOfferIsClosed: null,
                source: PaywallSource.lifetimeOfferAppLaunch,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      debugDefaultTargetPlatformOverride = null;
    }

    group('#LifetimeOfferSubscriptionCancelNotice', () {
      testWidgets('月額・年額プランで課金中（プレミアムかつ買い切り未購入）の場合は解約誘導文言が表示される',
          (WidgetTester tester) async {
        await pumpLifetimeOfferPageBody(
          tester,
          user: const User(
            isPremium: true,
            trialDeadlineDate: null,
            beginTrialDate: null,
            discountEntitlementDeadlineDate: null,
          ),
        );

        expect(
          find.byWidgetPredicate(
              (widget) => widget is LifetimeOfferSubscriptionCancelNotice),
          findsOneWidget,
        );
      });

      testWidgets('非課金ユーザーの場合は解約誘導文言が表示されない', (WidgetTester tester) async {
        await pumpLifetimeOfferPageBody(
          tester,
          user: const User(
            isPremium: false,
            trialDeadlineDate: null,
            beginTrialDate: null,
            discountEntitlementDeadlineDate: null,
          ),
        );

        expect(
          find.byWidgetPredicate(
              (widget) => widget is LifetimeOfferSubscriptionCancelNotice),
          findsNothing,
        );
      });

      testWidgets('プレミアムでも買い切り購入済みの場合は解約誘導文言が表示されない',
          (WidgetTester tester) async {
        await pumpLifetimeOfferPageBody(
          tester,
          user: const User(
            isPremium: true,
            trialDeadlineDate: null,
            beginTrialDate: null,
            discountEntitlementDeadlineDate: null,
          ),
          isLifetimePurchased: true,
        );

        expect(
          find.byWidgetPredicate(
              (widget) => widget is LifetimeOfferSubscriptionCancelNotice),
          findsNothing,
        );
      });
    });

    group('#LifetimeOfferPriceCard', () {
      testWidgets('割引packageが取得できている場合は価格カードが表示される',
          (WidgetTester tester) async {
        await pumpLifetimeOfferPageBody(
          tester,
          user: const User(
            isPremium: false,
            trialDeadlineDate: null,
            beginTrialDate: null,
            discountEntitlementDeadlineDate: null,
          ),
        );

        expect(
          find.byWidgetPredicate((widget) => widget is LifetimeOfferPriceCard),
          findsOneWidget,
        );
      });

      testWidgets('割引packageが取得できない場合はインジケータが表示される',
          (WidgetTester tester) async {
        await pumpLifetimeOfferPageBody(
          tester,
          user: const User(
            isPremium: false,
            trialDeadlineDate: null,
            beginTrialDate: null,
            discountEntitlementDeadlineDate: null,
          ),
          hasLifetimeDiscountPackage: false,
        );

        expect(
          find.byWidgetPredicate((widget) => widget is ScaffoldIndicator),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate((widget) => widget is LifetimeOfferPriceCard),
          findsNothing,
        );
      });
    });

    group('利用日数の表示', () {
      testWidgets('creationTimeからの経過日数が表示される', (WidgetTester tester) async {
        await pumpLifetimeOfferPageBody(
          tester,
          user: const User(
            isPremium: false,
            trialDeadlineDate: null,
            beginTrialDate: null,
            discountEntitlementDeadlineDate: null,
          ),
        );

        expect(
            find.text('Pilllを使い始めて340日', findRichText: true), findsOneWidget);
      });
    });
  });
}
