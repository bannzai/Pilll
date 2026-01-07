import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:pilll/entity/remote_config_parameter.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/record/components/announcement_bar/components/admob.dart';
import 'package:pilll/provider/purchase.dart';
import 'package:pilll/provider/remote_config_parameter.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pilll_ads.dart';
import 'package:pilll/features/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/features/record/components/announcement_bar/components/discount_price_deadline.dart';
import 'package:pilll/features/record/components/announcement_bar/components/ended_pill_sheet.dart';
import 'package:pilll/features/record/components/announcement_bar/components/lifetime_subscription_warning.dart';
import 'package:pilll/features/record/components/announcement_bar/components/pilll_ads.dart';
import 'package:pilll/features/record/components/announcement_bar/announcement_bar.dart';
import 'package:pilll/features/record/components/announcement_bar/components/premium_trial_limit.dart';
import 'package:pilll/features/record/components/announcement_bar/components/recommend_signup_premium.dart';
import 'package:pilll/features/record/components/announcement_bar/components/rest_duration.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/pilll_ads.codegen.dart';
import 'package:pilll/provider/locale.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/utils/remote_config.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/fake.dart';
import '../../../helper/mock.mocks.dart';

void main() {
  const totalCountOfActionForTakenPillForLongTimeUser = 14;

  setUp(() {
    /// 下のコードはもう不要だが、iOSで固定しておく
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    TestWidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
    for (var element in RendererBinding.instance.renderViews) {
      element.configuration = TestViewConfiguration.fromView(
        view: WidgetsBinding.instance.platformDispatcher.views.single,
        size: const Size(375.0, 667.0),
      );
    }
  });

  group('notification bar appearance content type', () {
    group('for it is not premium user', () {
      testWidgets('#DiscountPriceDeadline', (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime(2021, 04, 29);

        when(mockTodayRepository.now()).thenReturn(mockToday);
        todayRepository = mockTodayRepository;

        var pillSheet = PillSheet.create(
          PillSheetType.pillsheet_21,
          lastTakenDate: mockToday,
          beginDate: mockToday.subtract(
// NOTE: Into rest duration and notification duration
            const Duration(days: 25),
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );
        SharedPreferences.setMockInitialValues({
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appIsReleasedProvider.overrideWith((ref) => true),
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
              userProvider.overrideWith((ref) {
                return Stream.value(
                  User(
                    isPremium: false,
                    trialDeadlineDate: mockToday.subtract(const Duration(days: 1)),
                    beginTrialDate: mockToday.subtract(const Duration(days: 2)),
                    discountEntitlementDeadlineDate: mockToday.add(const Duration(days: 2)),
                  ),
                );
              }),
              isLinkedProvider.overrideWithValue(false),
              isJaLocaleProvider.overrideWithValue(true),
              hiddenCountdownDiscountDeadlineProvider(discountEntitlementDeadlineDate: mockToday.subtract(const Duration(days: 1)))
                  .overrideWith((provider) => false),
              durationToDiscountPriceDeadlineProvider(discountEntitlementDeadlineDate: mockToday.subtract(const Duration(days: 1)))
                  .overrideWithValue(const Duration(seconds: 1000)),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              annualPackageProvider.overrideWith((ref, user) => FakeRevenueCatPackage()),
              monthlyPackageProvider.overrideWith((ref, user) => FakeRevenueCatPackage()),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pump();

        debugDefaultTargetPlatformOverride = null;

        expect(
          find.byWidgetPredicate((widget) => widget is DiscountPriceDeadline),
          findsOneWidget,
        );
      });

      testWidgets('#PremiumTrialLimitAnnouncementBar', (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime(2021, 04, 29);
        final n = today();

        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(n);
        todayRepository = mockTodayRepository;

        var pillSheet = PillSheet.create(
          PillSheetType.pillsheet_21,
          lastTakenDate: mockToday,
          beginDate: mockToday.subtract(
// NOTE: Not into rest duration and notification duration
            const Duration(days: 10),
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        SharedPreferences.setMockInitialValues({
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appIsReleasedProvider.overrideWith((ref) => true),
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
              userProvider.overrideWith(
                (ref) => Stream.value(
                  User(
                    isPremium: false,
                    trialDeadlineDate: mockToday.add(const Duration(days: 1)),
                    beginTrialDate: null,
                    discountEntitlementDeadlineDate: null,
                  ),
                ),
              ),
              isLinkedProvider.overrideWithValue(false),
              isJaLocaleProvider.overrideWithValue(true),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pump();

        debugDefaultTargetPlatformOverride = null;

        expect(
          find.byWidgetPredicate((widget) => widget is PremiumTrialLimitAnnouncementBar),
          findsOneWidget,
        );
      });
      testWidgets('#EndedPillSheet', (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime(2021, 04, 29);
        final n = today();

        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(n);
        todayRepository = mockTodayRepository;

        var pillSheet = PillSheet.create(
          PillSheetType.pillsheet_21,
          lastTakenDate: mockToday.subtract(const Duration(days: 1)),
          beginDate: mockToday.subtract(
// NOTE: To deactive pill sheet
            const Duration(days: 30),
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        SharedPreferences.setMockInitialValues({
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appIsReleasedProvider.overrideWith((ref) => true),
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
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
              isLinkedProvider.overrideWithValue(true),
              isJaLocaleProvider.overrideWithValue(true),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 400));

        debugDefaultTargetPlatformOverride = null;

        expect(
          find.byWidgetPredicate((widget) => widget is EndedPillSheet),
          findsOneWidget,
        );
      });

      group("#AdMob", () {
        testWidgets('!isPremium and !isTrial', (WidgetTester tester) async {
          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: today().subtract(const Duration(days: 1)),
            beginDate: today().subtract(
              const Duration(days: 25),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
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
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith((ref) => Stream.value(null)),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 400));

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is AdMob),
            findsOneWidget,
          );
        });
        testWidgets('use is premium', (WidgetTester tester) async {
          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: today().subtract(const Duration(days: 1)),
            beginDate: today().subtract(
              const Duration(days: 25),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                userProvider.overrideWith(
                  (ref) => Stream.value(
                    const User(
                      isPremium: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith((ref) => Stream.value(null)),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 400));

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is AdMob),
            findsNothing,
          );
        });
        testWidgets('user is trial', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2021, 04, 29);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday.subtract(const Duration(days: 1)),
            beginDate: mockToday.subtract(
              const Duration(days: 25),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                userProvider.overrideWith(
                  (ref) => Stream.value(
                    User(
                      isPremium: false,
                      trialDeadlineDate: mockToday.add(const Duration(days: 1)),
                      beginTrialDate: mockToday.subtract(const Duration(days: 2)),
                      discountEntitlementDeadlineDate: mockToday.add(const Duration(days: 2)),
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith((ref) => Stream.value(null)),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 400));

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is AdMob),
            findsNothing,
          );
        });
      });
      group("#PilllAdsAnnouncementBar", () {
        testWidgets('today is before 2022-08-10, pilll-ads is start 2022-08-10', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2022, 08, 10).subtract(const Duration(seconds: 1));

          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday.subtract(const Duration(days: 1)),
            beginDate: mockToday.subtract(
              const Duration(days: 25),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
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
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(PilllAds(
                    description: 'これは広告用のテキスト',
                    destinationURL: 'https://github.com/bannzai',
                    endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                    startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                    hexColor: '#111111',
                    imageURL: null,
                  )),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 400));

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsNothing,
          );
        });
        testWidgets('today is 2022-08-10, pilll-ads is start 2022-08-10', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2022, 08, 10);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday.subtract(const Duration(days: 1)),
            beginDate: mockToday.subtract(
              const Duration(days: 25),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
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
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsOneWidget,
          );
        });
        testWidgets('today is 2022-08-11, pilll-ads is start 2022-08-10', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2022, 08, 11);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday.subtract(const Duration(days: 1)),
            beginDate: mockToday.subtract(
              const Duration(days: 25),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
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
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsOneWidget,
          );
        });
        testWidgets('now is 2022-08-23T23:59:59, pilll-ads is end 2022-08-23T23:59:59', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2022, 08, 23, 23, 59, 59);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday.subtract(const Duration(days: 1)),
            beginDate: mockToday.subtract(
              const Duration(days: 25),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
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
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsOneWidget,
          );
        });
        testWidgets('now is 2022-08-24T00:00:00, pilll-ads is end 2022-08-23T23:59:59', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2022, 08, 24);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday.subtract(const Duration(days: 1)),
            beginDate: mockToday.subtract(
              const Duration(days: 25),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
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
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsNothing,
          );
        });
      });
    });

    group('for it is premium user', () {
      group('#LifetimeSubscriptionWarningAnnouncementBar', () {
        testWidgets('lifetime購入者で閉じていない場合は表示される', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2021, 04, 29);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday,
            beginDate: mockToday.subtract(const Duration(days: 10)),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ['1'],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.lifetimeSubscriptionWarningIsClosed: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                userProvider.overrideWith(
                  (ref) => Stream.value(
                    const User(
                      isPremium: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(true),
                isJaLocaleProvider.overrideWithValue(true),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
                isLifetimePurchasedProvider.overrideWith((ref) => Future.value(true)),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is LifetimeSubscriptionWarningAnnouncementBar),
            findsOneWidget,
          );
        });

        testWidgets('lifetime購入者で閉じた場合は表示されない', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2021, 04, 29);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday,
            beginDate: mockToday.subtract(const Duration(days: 10)),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ['1'],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.lifetimeSubscriptionWarningIsClosed: true,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                userProvider.overrideWith(
                  (ref) => Stream.value(
                    const User(
                      isPremium: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(true),
                isJaLocaleProvider.overrideWithValue(true),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
                isLifetimePurchasedProvider.overrideWith((ref) => Future.value(true)),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is LifetimeSubscriptionWarningAnnouncementBar),
            findsNothing,
          );
        });

        testWidgets('lifetime購入者でない場合は表示されない', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2021, 04, 29);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday,
            beginDate: mockToday.subtract(const Duration(days: 10)),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ['1'],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.lifetimeSubscriptionWarningIsClosed: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                userProvider.overrideWith(
                  (ref) => Stream.value(
                    const User(
                      isPremium: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
                isLifetimePurchasedProvider.overrideWith((ref) => Future.value(false)),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is LifetimeSubscriptionWarningAnnouncementBar),
            findsNothing,
          );
          // lifetime購入者でない場合、isLinkedProvider=falseなのでRecommendSignupForPremiumAnnouncementBarが表示される
          expect(
            find.byWidgetPredicate((widget) => widget is RecommendSignupForPremiumAnnouncementBar),
            findsOneWidget,
          );
        });

        testWidgets('isLifetimePurchasedがloadingの場合は表示されない', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2021, 04, 29);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday,
            beginDate: mockToday.subtract(const Duration(days: 10)),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ['1'],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.lifetimeSubscriptionWarningIsClosed: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                userProvider.overrideWith(
                  (ref) => Stream.value(
                    const User(
                      isPremium: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
                // 永遠にresolveしないFuture（loading状態）
                isLifetimePurchasedProvider.overrideWith((ref) => Completer<bool>().future),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is LifetimeSubscriptionWarningAnnouncementBar),
            findsNothing,
          );
          // loading時はisLinkedProvider=falseなのでRecommendSignupForPremiumAnnouncementBarが表示される
          expect(
            find.byWidgetPredicate((widget) => widget is RecommendSignupForPremiumAnnouncementBar),
            findsOneWidget,
          );
        });
      });

      group("#PilllAdsAnnouncementBar", () {
        testWidgets('today is before 2022-08-10', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2022, 08, 10).subtract(const Duration(seconds: 1));

          when(mockTodayRepository.now()).thenReturn(mockToday);
          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday,
            beginDate: mockToday.subtract(
              // NOTE: Not into rest duration and notification duration
              const Duration(days: 10),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                userProvider.overrideWith(
                  (ref) => Stream.value(
                    const User(
                      isPremium: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsNothing,
          );
        });
        testWidgets('today is 2022-08-10', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2022, 08, 10);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday,
            beginDate: mockToday.subtract(
              // NOTE: Not into rest duration and notification duration
              const Duration(days: 10),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                userProvider.overrideWith(
                  (ref) => Stream.value(
                    const User(
                      isPremium: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsNothing,
          );
        });
        testWidgets('today is 2022-08-11', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2022, 08, 11);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday,
            beginDate: mockToday.subtract(
              // NOTE: Not into rest duration and notification duration
              const Duration(days: 10),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                userProvider.overrideWith(
                  (ref) => Stream.value(
                    const User(
                      isPremium: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsNothing,
          );
        });
        testWidgets('now is 2022-08-23T23:59:59', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2022, 08, 23, 23, 59, 59);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday,
            beginDate: mockToday.subtract(
              // NOTE: Not into rest duration and notification duration
              const Duration(days: 10),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                userProvider.overrideWith(
                  (ref) => Stream.value(
                    const User(
                      isPremium: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsNothing,
          );
        });
        testWidgets('now is 2022-08-23T23:59:59 and already closed', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2022, 08, 23, 23, 59, 59);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday,
            beginDate: mockToday.subtract(
              // NOTE: Not into rest duration and notification duration
              const Duration(days: 10),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                userProvider.overrideWith(
                  (ref) => Stream.value(
                    const User(
                      isPremium: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsNothing,
          );
        });
        testWidgets('now is 2022-08-24T00:00:00', (WidgetTester tester) async {
          final mockTodayRepository = MockTodayService();
          final mockToday = DateTime(2022, 08, 24);

          when(mockTodayRepository.now()).thenReturn(mockToday);
          when(mockTodayRepository.now()).thenReturn(mockToday);
          todayRepository = mockTodayRepository;

          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: mockToday,
            beginDate: mockToday.subtract(
              // NOTE: Not into rest duration and notification duration
              const Duration(days: 10),
            ),
          );
          final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["1"],
            pillSheets: [pillSheet],
            createdAt: now(),
            pillSheetAppearanceMode: PillSheetAppearanceMode.number,
          );

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                appIsReleasedProvider.overrideWith((ref) => true),
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                userProvider.overrideWith(
                  (ref) => Stream.value(
                    const User(
                      isPremium: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          debugDefaultTargetPlatformOverride = null;

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsNothing,
          );
        });
      });
      testWidgets('#RecommendSignupForPremiumAnnouncementBar', (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime(2021, 04, 29);

        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        todayRepository = mockTodayRepository;

        var pillSheet = PillSheet.create(
          PillSheetType.pillsheet_21,
          lastTakenDate: mockToday,
          beginDate: mockToday.subtract(
// NOTE: Not into rest duration and notification duration
            const Duration(days: 10),
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        SharedPreferences.setMockInitialValues({
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appIsReleasedProvider.overrideWith((ref) => true),
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
              userProvider.overrideWith(
                (ref) => Stream.value(
                  const User(
                    isPremium: true,
                    trialDeadlineDate: null,
                    beginTrialDate: null,
                    discountEntitlementDeadlineDate: null,
                  ),
                ),
              ),
              isLinkedProvider.overrideWithValue(false),
              isJaLocaleProvider.overrideWithValue(true),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pump();

        debugDefaultTargetPlatformOverride = null;

        expect(
          find.byWidgetPredicate((widget) => widget is RecommendSignupForPremiumAnnouncementBar),
          findsOneWidget,
        );
      });

      testWidgets('#RestDurationAnnouncementBar', (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime(2021, 04, 29);

        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(mockToday);
        todayRepository = mockTodayRepository;

        var pillSheet = PillSheet.create(
          PillSheetType.pillsheet_21,
          lastTakenDate: mockToday,
          beginDate: mockToday.subtract(
// NOTE: Into rest duration and notification duration
            const Duration(days: 25),
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        SharedPreferences.setMockInitialValues({
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appIsReleasedProvider.overrideWith((ref) => true),
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
              userProvider.overrideWith(
                (ref) => Stream.value(
                  const User(
                    isPremium: true,
                    trialDeadlineDate: null,
                    beginTrialDate: null,
                    discountEntitlementDeadlineDate: null,
                  ),
                ),
              ),
              isLinkedProvider.overrideWithValue(true),
              isJaLocaleProvider.overrideWithValue(true),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pump();

        debugDefaultTargetPlatformOverride = null;

        expect(
          find.byWidgetPredicate((widget) => widget is RestDurationAnnouncementBar),
          findsOneWidget,
        );
      });
      testWidgets('#EndedPillSheet', (WidgetTester tester) async {
        final mockTodayRepository = MockTodayService();
        final mockToday = DateTime(2021, 04, 29);
        final n = today();

        when(mockTodayRepository.now()).thenReturn(mockToday);
        when(mockTodayRepository.now()).thenReturn(n);
        todayRepository = mockTodayRepository;

        var pillSheet = PillSheet.create(
          PillSheetType.pillsheet_21,
          lastTakenDate: mockToday.subtract(const Duration(days: 1)),
          beginDate: mockToday.subtract(
// NOTE: To deactive pill sheet
            const Duration(days: 30),
          ),
        );
        final pillSheetGroup = PillSheetGroup(
          pillSheetIDs: ["1"],
          pillSheets: [pillSheet],
          createdAt: now(),
          pillSheetAppearanceMode: PillSheetAppearanceMode.number,
        );

        SharedPreferences.setMockInitialValues({
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appIsReleasedProvider.overrideWith((ref) => true),
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
              userProvider.overrideWith(
                (ref) => Stream.value(
                  const User(
                    isPremium: true,
                    trialDeadlineDate: null,
                    beginTrialDate: null,
                    discountEntitlementDeadlineDate: null,
                  ),
                ),
              ),
              isLinkedProvider.overrideWithValue(true),
              isJaLocaleProvider.overrideWithValue(true),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              remoteConfigParameterProvider.overrideWithValue(RemoteConfigParameter()),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pump();

        debugDefaultTargetPlatformOverride = null;

        expect(
          find.byWidgetPredicate((widget) => widget is EndedPillSheet),
          findsOneWidget,
        );
      });
    });
  });
}
