import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/lifetime_offer/page.dart';
import 'package:pilll/features/root/resolver/show_lifetime_offer_on_app_launch.dart';
import 'package:pilll/features/root/resolver/show_paywall_on_app_launch.dart';
import 'package:pilll/provider/app_is_released.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/provider/tick.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/fake.dart';
import '../../../helper/mock.mocks.dart';

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
    // showLifetimeOfferPage の logScreenView がFirebase未初期化の例外を投げるためFakeに差し替える
    analytics = FakeAnalytics();
    for (var element in RendererBinding.instance.renderViews) {
      element.configuration = TestViewConfiguration.fromView(
        view: WidgetsBinding.instance.platformDispatcher.views.single,
        size: const Size(414.0, 896.0),
      );
    }
  });

  group('#ShowLifetimeOfferOnAppLaunch', () {
    // 買い切りオファーの表示条件を満たした状態でResolverを起動する
    Future<SharedPreferences> pumpShowLifetimeOfferOnAppLaunch(
      WidgetTester tester, {
      Map<String, Object> initialSharedPreferencesValues = const {},
      bool shownPaywallOnThisAppLaunch = false,
    }) async {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime(2026, 7, 3);

      when(mockTodayRepository.now()).thenReturn(mockToday);
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues(initialSharedPreferencesValues);
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
            // 本物のTickはTimer.periodicを作りpumpAndSettleが完了しないためFakeに差し替える
            tickProvider.overrideWith(() => FakeTick(fakeDateTime: mockToday)),
            remoteConfigParameterProvider.overrideWithValue(
              RemoteConfigParameter(lifetimeOfferEnabled: true),
            ),
            isLifetimePurchasedProvider.overrideWith(
              (ref) => Future.value(false),
            ),
            lifetimeDiscountPackageProvider.overrideWith(
              (ref) => _LifetimeFakePackage(),
            ),
            lifetimePremiumPackageProvider.overrideWith(
              (ref) => _LifetimeFakePackage(),
            ),
            lifetimeDiscountRateProvider.overrideWith((ref) => 40.0),
            appIsReleasedProvider.overrideWith((ref) => true),
            firebaseUserStateProvider.overrideWith(
              (ref) => Stream.value(
                FakeFirebaseAuthUser(
                  fakeCreationTime:
                      mockToday.subtract(const Duration(days: 340)),
                ),
              ),
            ),
            userProvider.overrideWith(
              (ref) => Stream.value(
                const User(
                  isPremium: false,
                  trialDeadlineDate: null,
                  beginTrialDate: null,
                  discountEntitlementDeadlineDate: null,
                ),
              ),
            ),
            shownPaywallOnThisAppLaunchProvider.overrideWith(
              (ref) => shownPaywallOnThisAppLaunch,
            ),
          ],
          child: MaterialApp(
            home: ShowLifetimeOfferOnAppLaunch(
              builder: (_) => const Scaffold(body: SizedBox.shrink()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      debugDefaultTargetPlatformOverride = null;
      return sharedPreferences;
    }

    testWidgets('表示条件を満たし未表示の場合は起動時にモーダルが表示され、表示済みフラグと初回表示時刻が記録される',
        (WidgetTester tester) async {
      final sharedPreferences = await pumpShowLifetimeOfferOnAppLaunch(tester);

      expect(
        find.byWidgetPredicate((widget) => widget is LifetimeOfferPage),
        findsOneWidget,
      );
      expect(
        sharedPreferences.getBool(BoolKey.lifetimeOfferAutoModalShown),
        isTrue,
      );
      expect(
        sharedPreferences
            .getString(StringKey.lifetimeOfferFirstDisplayedDateTime),
        DateTime(2026, 7, 3).toIso8601String(),
      );
    });

    testWidgets('初回表示時刻がセット済みの場合は上書きされない（set-if-absent）',
        (WidgetTester tester) async {
      final sharedPreferences = await pumpShowLifetimeOfferOnAppLaunch(
        tester,
        initialSharedPreferencesValues: {
          StringKey.lifetimeOfferFirstDisplayedDateTime:
              DateTime(2026, 7, 2, 9, 0, 0).toIso8601String(),
        },
      );

      expect(
        sharedPreferences
            .getString(StringKey.lifetimeOfferFirstDisplayedDateTime),
        DateTime(2026, 7, 2, 9, 0, 0).toIso8601String(),
      );
    });

    testWidgets('表示済みフラグが立っている場合はモーダルが表示されない', (WidgetTester tester) async {
      await pumpShowLifetimeOfferOnAppLaunch(
        tester,
        initialSharedPreferencesValues: {
          BoolKey.lifetimeOfferAutoModalShown: true,
        },
      );

      expect(
        find.byWidgetPredicate((widget) => widget is LifetimeOfferPage),
        findsNothing,
      );
    });

    testWidgets('同一起動で起動時ペイウォールが表示済みの場合はモーダルが表示されず、フラグも初回表示時刻も記録されない',
        (WidgetTester tester) async {
      final sharedPreferences = await pumpShowLifetimeOfferOnAppLaunch(
        tester,
        shownPaywallOnThisAppLaunch: true,
      );

      expect(
        find.byWidgetPredicate((widget) => widget is LifetimeOfferPage),
        findsNothing,
      );
      expect(
        sharedPreferences.getBool(BoolKey.lifetimeOfferAutoModalShown),
        isNull,
      );
      expect(
        sharedPreferences
            .getString(StringKey.lifetimeOfferFirstDisplayedDateTime),
        isNull,
      );
    });
  });
}
