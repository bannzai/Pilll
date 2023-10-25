import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/features/premium_introduction/components/premium_introduction_discount.dart';
import 'package:pilll/features/premium_introduction/components/premium_user_thanks.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/features/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

class _FakeOfferings extends Fake implements Offerings {}

class _MonthlyFakeProduct extends Fake implements StoreProduct {
  @override
  String get priceString => "";
  @override
  double get price => 300;
}

class _MonthlyFakePackage extends Fake implements Package {
  @override
  StoreProduct get storeProduct => _MonthlyFakeProduct();
  @override
  PackageType get packageType => PackageType.monthly;
}

class _AnnualFakeProduct extends Fake implements StoreProduct {
  @override
  String get priceString => "";
  @override
  double get price => 3600;
}

class _AnnualFakePackage extends Fake implements Package {
  @override
  StoreProduct get storeProduct => _AnnualFakeProduct();
  @override
  PackageType get packageType => PackageType.annual;
}

class _FakeUser extends Fake implements User {
  _FakeUser({
    required this.fakeIsPremium,
    required this.fakeHasDiscountEntitlement,
    required this.fakeDiscountEntitlementDeadlineDate,
  });
  final bool fakeIsPremium;
  final bool fakeHasDiscountEntitlement;
  final DateTime? fakeDiscountEntitlementDeadlineDate;

  @override
  bool get isPremium => fakeIsPremium;
  @override
  bool get hasDiscountEntitlement => fakeHasDiscountEntitlement;
  @override
  DateTime? get discountEntitlementDeadlineDate => fakeDiscountEntitlementDeadlineDate;
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({BoolKey.recommendedSignupNotificationIsAlreadyShow: true});
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
    analytics = MockAnalytics();
    WidgetsBinding.instance.renderView.configuration = TestViewConfiguration.fromView(
      view: WidgetsBinding.instance.platformDispatcher.views.single,
      size: const Size(375.0, 667.0),
    );
  });
  group('#PremiumIntroductionSheet', () {
    final mockTodayRepository = MockTodayService();
    final mockToday = DateTime(2021, 04, 29);
    final discountEntitlementDeadlineDate = mockToday.subtract(const Duration(days: 1));

    when(mockTodayRepository.now()).thenReturn(mockToday);
    todayRepository = mockTodayRepository;

    group('user is premium', () {
      testWidgets('#PremiumIntroductionDiscountRow is not found and #PremiumUserThanksRow is found', (WidgetTester tester) async {
        final user = _FakeUser(
          fakeIsPremium: true,
          fakeHasDiscountEntitlement: true, // NOTE: Nasty data
          fakeDiscountEntitlementDeadlineDate: null,
        );

        const sheet = PremiumIntroductionSheet();
        await tester.pumpWidget(
          MaterialApp(
            home: ProviderScope(
              overrides: [
                purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
                currentOfferingPackagesProvider.overrideWith((ref, arg) => [_MonthlyFakePackage(), _AnnualFakePackage()]),
                monthlyPremiumPackageProvider.overrideWith((ref, arg) => _MonthlyFakePackage()),
                userProvider.overrideWith((ref) => Stream.value(user)),
                isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate: discountEntitlementDeadlineDate).overrideWithValue(true),
                durationToDiscountPriceDeadlineProvider(discountEntitlementDeadlineDate: discountEntitlementDeadlineDate)
                    .overrideWithValue(const Duration(seconds: 1000)),
              ],
              child: const MaterialApp(
                home: sheet,
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate((widget) => widget is PremiumIntroductionDiscountRow),
          findsNothing,
        );
        expect(
          find.byWidgetPredicate((widget) => widget is PremiumUserThanksRow),
          findsOneWidget,
        );
      });
    });
    group('user has discount entitlements', () {
      const hasDiscountEntitlement = true;
      const isOverDiscountDeadline = false;
      testWidgets('#PremiumIntroductionDiscountRow is found', (WidgetTester tester) async {
        var user = _FakeUser(
          fakeIsPremium: false,
          fakeHasDiscountEntitlement: hasDiscountEntitlement,
          fakeDiscountEntitlementDeadlineDate: discountEntitlementDeadlineDate,
        );

        const sheet = PremiumIntroductionSheet();
        await tester.pumpWidget(
          MaterialApp(
            home: ProviderScope(
              overrides: [
                purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
                currentOfferingPackagesProvider.overrideWith((ref, arg) => [_MonthlyFakePackage(), _AnnualFakePackage()]),
                monthlyPremiumPackageProvider.overrideWith((ref, arg) => _MonthlyFakePackage()),
                userProvider.overrideWith((ref) => Stream.value(user)),
                isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate: discountEntitlementDeadlineDate)
                    .overrideWithValue(isOverDiscountDeadline),
                durationToDiscountPriceDeadlineProvider(discountEntitlementDeadlineDate: discountEntitlementDeadlineDate)
                    .overrideWithValue(const Duration(seconds: 1000)),
              ],
              child: const MaterialApp(
                home: sheet,
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate((widget) => widget is PremiumIntroductionDiscountRow),
          findsOneWidget,
        );
      });
    });
    group('user does not has discount entitlements', () {
      const hasDiscountEntitlement = false;
      testWidgets('#PremiumIntroductionDiscountRow is not found', (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime(2021, 04, 29);

        when(mockTodayRepository.now()).thenReturn(mockToday);
        todayRepository = mockTodayRepository;

        final user = _FakeUser(
          fakeIsPremium: false,
          fakeHasDiscountEntitlement: hasDiscountEntitlement,
          fakeDiscountEntitlementDeadlineDate: mockToday.subtract(const Duration(days: 1)),
        );

        const sheet = PremiumIntroductionSheet();
        await tester.pumpWidget(
          MaterialApp(
            home: ProviderScope(
              overrides: [
                purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
                currentOfferingPackagesProvider.overrideWith((ref, arg) => [_MonthlyFakePackage(), _AnnualFakePackage()]),
                monthlyPremiumPackageProvider.overrideWith((ref, arg) => _MonthlyFakePackage()),
                userProvider.overrideWith((ref) => Stream.value(user)),
                isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate: discountEntitlementDeadlineDate).overrideWithValue(false),
                durationToDiscountPriceDeadlineProvider(discountEntitlementDeadlineDate: discountEntitlementDeadlineDate)
                    .overrideWithValue(const Duration(seconds: 1000)),
              ],
              child: const MaterialApp(
                home: sheet,
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate((widget) => widget is PremiumIntroductionDiscountRow),
          findsNothing,
        );
      });
    });
    group('is over discount deadline ', () {
      const isOverDiscountDeadline = true;
      testWidgets('#PremiumIntroductionDiscountRow is found', (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime(2021, 04, 29);

        when(mockTodayRepository.now()).thenReturn(mockToday);
        todayRepository = mockTodayRepository;

        final user = _FakeUser(
          fakeIsPremium: false,
          fakeHasDiscountEntitlement: true,
          fakeDiscountEntitlementDeadlineDate: mockToday.subtract(const Duration(days: 1)),
        );

        const sheet = PremiumIntroductionSheet();
        await tester.pumpWidget(
          MaterialApp(
            home: ProviderScope(
              overrides: [
                purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
                currentOfferingPackagesProvider.overrideWith((ref, arg) => [_MonthlyFakePackage(), _AnnualFakePackage()]),
                monthlyPremiumPackageProvider.overrideWith((ref, arg) => _MonthlyFakePackage()),
                userProvider.overrideWith((ref) => Stream.value(user)),
                isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate: discountEntitlementDeadlineDate)
                    .overrideWithValue(isOverDiscountDeadline),
                durationToDiscountPriceDeadlineProvider(discountEntitlementDeadlineDate: discountEntitlementDeadlineDate)
                    .overrideWithValue(const Duration(seconds: 1000)),
              ],
              child: const MaterialApp(
                home: sheet,
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate((widget) => widget is PremiumIntroductionDiscountRow),
          findsOneWidget,
        );
      });
    });
    group('discount entitlemenet deadline date is null', () {
      testWidgets('#PremiumIntroductionDiscountRow is found', (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime(2021, 04, 29);

        when(mockTodayRepository.now()).thenReturn(mockToday);
        todayRepository = mockTodayRepository;

        var user = _FakeUser(
          fakeIsPremium: false,
          fakeHasDiscountEntitlement: true,
          fakeDiscountEntitlementDeadlineDate: null,
        );

        const sheet = PremiumIntroductionSheet();
        await tester.pumpWidget(
          MaterialApp(
            home: ProviderScope(
              overrides: [
                purchaseOfferingsProvider.overrideWith((ref) => _FakeOfferings()),
                currentOfferingPackagesProvider.overrideWith((ref, arg) => [_MonthlyFakePackage(), _AnnualFakePackage()]),
                monthlyPremiumPackageProvider.overrideWith((ref, arg) => _MonthlyFakePackage()),
                userProvider.overrideWith((ref) => Stream.value(user)),
                isOverDiscountDeadlineProvider(discountEntitlementDeadlineDate: discountEntitlementDeadlineDate).overrideWithValue(false),
                durationToDiscountPriceDeadlineProvider(discountEntitlementDeadlineDate: discountEntitlementDeadlineDate)
                    .overrideWithValue(const Duration(seconds: 1000)),
              ],
              child: const MaterialApp(
                home: sheet,
              ),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate((widget) => widget is PremiumIntroductionDiscountRow),
          findsWidgets,
        );
      });
    });
  });
}
