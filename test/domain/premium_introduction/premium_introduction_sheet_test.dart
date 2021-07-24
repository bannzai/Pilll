import 'package:pilll/analytics.dart';
import 'package:pilll/domain/premium_introduction/components/premium_introduction_discount.dart';
import 'package:pilll/domain/premium_introduction/components/purchase_buttons_state.dart';
import 'package:pilll/domain/premium_introduction/components/purchase_buttons_store.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_state.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_store.dart';
import 'package:pilll/domain/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

class _FakeOfferings extends Fake implements Offerings {}

class _MonthlyFakeProduct extends Fake implements Product {
  @override
  String get priceString => "";
  @override
  double get price => 300;
}

class _MonthlyFakePackage extends Fake implements Package {
  @override
  Product get product => _MonthlyFakeProduct();
}

class _AnnualFakeProduct extends Fake implements Product {
  @override
  String get priceString => "";
  @override
  double get price => 3600;
}

class _AnnualFakePackage extends Fake implements Package {
  @override
  Product get product => _AnnualFakeProduct();
}

class _FakePurchaseButtonState extends Fake implements PurchaseButtonsState {
  @override
  Package? get monthlyPackage => _MonthlyFakePackage();
  @override
  Package? get annualPackage => _AnnualFakePackage();
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(
        {BoolKey.recommendedSignupNotificationIsAlreadyShow: true});
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
    analytics = MockAnalytics();
    WidgetsBinding.instance!.renderView.configuration =
        new TestViewConfiguration(size: const Size(375.0, 667.0));
  });
  group('#PremiumIntroductionSheet', () {
    final mockTodayRepository = MockTodayService();
    final today = DateTime(2021, 04, 29);
    final discountEntitlementDeadlineDate = today.subtract(Duration(days: 1));

    when(mockTodayRepository.today()).thenReturn(today);
    todayRepository = mockTodayRepository;
    group('user has discount entitlements', () {
      final hasDiscountEntitlement = true;
      final isOverDiscountDeadline = false;
      testWidgets('#PremiumIntroductionLimited is found',
          (WidgetTester tester) async {
        var state = PremiumIntroductionState();
        state = state.copyWith(
          offerings: _FakeOfferings(),
          hasDiscountEntitlement: hasDiscountEntitlement,
          discountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
        );

        final sheet = PremiumIntroductionSheet();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              premiumIntroductionStateProvider.overrideWithValue(state),
              premiumIntroductionStoreProvider.overrideWithProvider(
                  StateNotifierProvider.autoDispose(
                      (ref) => MockPremiumIntroductionStore())),
              isOverDiscountDeadlineProvider
                  .overrideWithProvider((ref, param) => isOverDiscountDeadline),
              durationToDiscountPriceDeadline.overrideWithProvider(
                  (ref, param) => Duration(seconds: 1000)),
              purchaseButtonsStoreProvider.overrideWithProvider(
                  (ref, param) => MockPurchaseButtonsStore()),
              purchaseButtonStateProvider.overrideWithProvider(
                  (ref, param) => _FakePurchaseButtonState()),
            ],
            child: MaterialApp(
              home: sheet,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate(
              (widget) => widget is PremiumIntroductionDiscountRow),
          findsOneWidget,
        );
      });
    });
    group('user does not has discount entitlements', () {
      final hasDiscountEntitlement = false;
      testWidgets('#PremiumIntroductionLimited is not found',
          (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        final today = DateTime(2021, 04, 29);

        when(mockTodayRepository.today()).thenReturn(today);
        todayRepository = mockTodayRepository;

        var state = PremiumIntroductionState();
        state = state.copyWith(
          offerings: _FakeOfferings(),
          hasDiscountEntitlement: hasDiscountEntitlement,
          discountEntitlementDeadlineDate: today.subtract(Duration(days: 1)),
        );

        final sheet = PremiumIntroductionSheet();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              premiumIntroductionStateProvider.overrideWithValue(state),
              premiumIntroductionStoreProvider.overrideWithProvider(
                  StateNotifierProvider.autoDispose(
                      (ref) => MockPremiumIntroductionStore())),
              isOverDiscountDeadlineProvider
                  .overrideWithProvider((ref, param) => false),
              durationToDiscountPriceDeadline.overrideWithProvider(
                  (ref, param) => Duration(seconds: 1000)),
              purchaseButtonsStoreProvider.overrideWithProvider(
                  (ref, param) => MockPurchaseButtonsStore()),
              purchaseButtonStateProvider.overrideWithProvider(
                  (ref, param) => _FakePurchaseButtonState()),
            ],
            child: MaterialApp(
              home: sheet,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate(
              (widget) => widget is PremiumIntroductionDiscountRow),
          findsNothing,
        );
      });
    });
    group('is over discount deadline ', () {
      final isOverDiscountDeadline = true;
      testWidgets('#PremiumIntroductionDiscountRow is found',
          (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        final today = DateTime(2021, 04, 29);

        when(mockTodayRepository.today()).thenReturn(today);
        todayRepository = mockTodayRepository;

        var state = PremiumIntroductionState();
        state = state.copyWith(
          offerings: _FakeOfferings(),
          hasDiscountEntitlement: true,
          discountEntitlementDeadlineDate: today.subtract(Duration(days: 1)),
        );

        final sheet = PremiumIntroductionSheet();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              premiumIntroductionStateProvider.overrideWithValue(state),
              premiumIntroductionStoreProvider.overrideWithProvider(
                  StateNotifierProvider.autoDispose(
                      (ref) => MockPremiumIntroductionStore())),
              isOverDiscountDeadlineProvider
                  .overrideWithProvider((ref, param) => isOverDiscountDeadline),
              durationToDiscountPriceDeadline.overrideWithProvider(
                  (ref, param) => Duration(seconds: 1000)),
              purchaseButtonsStoreProvider.overrideWithProvider(
                  (ref, param) => MockPurchaseButtonsStore()),
              purchaseButtonStateProvider.overrideWithProvider(
                  (ref, param) => _FakePurchaseButtonState()),
            ],
            child: MaterialApp(
              home: sheet,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate(
              (widget) => widget is PremiumIntroductionDiscountRow),
          findsOneWidget,
        );
      });
    });
    group('discount entitlemenet deadline date is null', () {
      testWidgets('#PremiumIntroductionDiscountRow is found',
          (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        final today = DateTime(2021, 04, 29);

        when(mockTodayRepository.today()).thenReturn(today);
        todayRepository = mockTodayRepository;

        var state = PremiumIntroductionState();
        state = state.copyWith(
          offerings: _FakeOfferings(),
          hasDiscountEntitlement: true,
          discountEntitlementDeadlineDate: null,
        );

        final sheet = PremiumIntroductionSheet();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              premiumIntroductionStateProvider.overrideWithValue(state),
              premiumIntroductionStoreProvider.overrideWithProvider(
                  StateNotifierProvider.autoDispose(
                      (ref) => MockPremiumIntroductionStore())),
              isOverDiscountDeadlineProvider
                  .overrideWithProvider((ref, param) => false),
              durationToDiscountPriceDeadline.overrideWithProvider(
                  (ref, param) => Duration(seconds: 1000)),
              purchaseButtonsStoreProvider.overrideWithProvider(
                  (ref, param) => MockPurchaseButtonsStore()),
              purchaseButtonStateProvider.overrideWithProvider(
                  (ref, param) => _FakePurchaseButtonState()),
            ],
            child: MaterialApp(
              home: sheet,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate(
              (widget) => widget is PremiumIntroductionDiscountRow),
          findsWidgets,
        );
      });
    });
  });
}
