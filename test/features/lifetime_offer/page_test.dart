import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/lifetime_offer/lifetime_offer_copy_variant.dart';
import 'package:pilll/features/lifetime_offer/page.dart';
import 'package:pilll/features/lifetime_offer/provider.dart';
import 'package:pilll/features/premium_introduction/paywall_source.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/provider/tick.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      Map<String, Object> initialSharedPreferencesValues = const {},
      LifetimeOfferCopyVariant copyVariant =
          LifetimeOfferCopyVariant.defaultVariant,
    }) async {
      final mockTodayRepository = MockTodayService();
      when(mockTodayRepository.now()).thenReturn(DateTime(2026, 7, 3));
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues(initialSharedPreferencesValues);
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
            // 本物のTickはTimer.periodicを作りpending timerでテストが失敗するためFakeに差し替える
            tickProvider.overrideWith(
                () => FakeTick(fakeDateTime: DateTime(2026, 7, 3))),
            remoteConfigParameterProvider.overrideWithValue(
              RemoteConfigParameter(
                  lifetimeOfferCopyVariant: copyVariant.value),
            ),
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

    group('訴求コピーのバリアント', () {
      testWidgets('defaultバリアントで現行の訴求コピーが表示される', (WidgetTester tester) async {
        await pumpLifetimeOfferPageBody(
          tester,
          user: const User(
            isPremium: false,
            trialDeadlineDate: null,
            beginTrialDate: null,
            discountEntitlementDeadlineDate: null,
          ),
          copyVariant: LifetimeOfferCopyVariant.defaultVariant,
        );

        expect(find.text('長く使ってくださっている方へ\n買い切りプランのご案内です'), findsOneWidget);
        expect(find.text('一度の購入で、ずっとプレミアム。\n月々のお支払いは不要です'), findsNothing);
      });

      testWidgets('ownershipバリアントで所有価値訴求のコピーが表示される',
          (WidgetTester tester) async {
        await pumpLifetimeOfferPageBody(
          tester,
          user: const User(
            isPremium: false,
            trialDeadlineDate: null,
            beginTrialDate: null,
            discountEntitlementDeadlineDate: null,
          ),
          copyVariant: LifetimeOfferCopyVariant.ownership,
        );

        expect(find.text('一度の購入で、ずっとプレミアム。\n月々のお支払いは不要です'), findsOneWidget);
        expect(find.text('長く使ってくださっている方へ\n買い切りプランのご案内です'), findsNothing);
      });
    });

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

    group('#LifetimeOfferCountdownText', () {
      testWidgets('残り時間のカウントダウンが表示される（初回表示前は満額の24時間）',
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
          find.byWidgetPredicate(
              (widget) => widget is LifetimeOfferCountdownText),
          findsOneWidget,
        );
        expect(find.text('残り 24:00:00'), findsOneWidget);
      });
    });

    group('購入ボタンの無効化', () {
      testWidgets('表示期限切れの場合は購入ボタンが無効化され、終了メッセージが表示される',
          (WidgetTester tester) async {
        // 初回表示時刻: 2026-07-01 09:00 → 期限は+24時間の2026-07-02 09:00。現在時刻(tick)は2026-07-03で期限切れ
        await pumpLifetimeOfferPageBody(
          tester,
          user: const User(
            isPremium: false,
            trialDeadlineDate: null,
            beginTrialDate: null,
            discountEntitlementDeadlineDate: null,
          ),
          initialSharedPreferencesValues: {
            lifetimeOfferFirstDisplayedDateTimeKey(cycle: 0):
                DateTime(2026, 7, 1, 9, 0, 0).toIso8601String(),
          },
        );

        expect(
          tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
          isNull,
        );
        expect(find.text('このオファーは終了しました'), findsOneWidget);
      });

      testWidgets('買い切り購入済みの場合は購入ボタンが無効化される', (WidgetTester tester) async {
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
          tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
          isNull,
        );
      });

      testWidgets('期限内かつ未購入の場合は購入ボタンが有効', (WidgetTester tester) async {
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
          tester.widget<PrimaryButton>(find.byType(PrimaryButton)).onPressed,
          isNotNull,
        );
      });
    });
  });
}
