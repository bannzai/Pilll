import 'dart:async';

import 'package:pilll/entity/affiliate.codegen.dart';
import 'package:pilll/features/record/components/announcement_bar/components/affiliate.dart';
import 'package:pilll/provider/affiliate.dart';
import 'package:pilll/provider/package_info.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pilll_ads.dart';
import 'package:pilll/features/premium_introduction/util/discount_deadline.dart';
import 'package:pilll/features/record/components/announcement_bar/components/discount_price_deadline.dart';
import 'package:pilll/features/record/components/announcement_bar/components/ended_pill_sheet.dart';
import 'package:pilll/features/record/components/announcement_bar/components/pilll_ads.dart';
import 'package:pilll/features/record/components/announcement_bar/announcement_bar.dart';
import 'package:pilll/features/record/components/announcement_bar/components/premium_trial_limit.dart';
import 'package:pilll/features/record/components/announcement_bar/components/recommend_signup.dart';
import 'package:pilll/features/record/components/announcement_bar/components/recommend_signup_premium.dart';
import 'package:pilll/features/record/components/announcement_bar/components/rest_duration.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/pilll_ads.codegen.dart';
import 'package:pilll/provider/locale.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/auth.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:pilll/utils/version/version.dart';
import 'package:run_with_network_images/run_with_network_images.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/mock.mocks.dart';

void main() {
  const totalCountOfActionForTakenPillForLongTimeUser = 14;
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    initializeDateFormatting('ja_JP');
    Environment.isTest = true;
    analytics = MockAnalytics();
    WidgetsBinding.instance.renderView.configuration = TestViewConfiguration.fromView(
      view: WidgetsBinding.instance.platformDispatcher.views.single,
      size: const Size(375.0, 667.0),
    );
  });

  group('notification bar appearance content type', () {
    group('for it is not premium user', () {
      testWidgets('#DiscountPriceDeadline', (WidgetTester tester) async {
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
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());
        SharedPreferences.setMockInitialValues({
          BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
              premiumAndTrialProvider.overrideWithValue(
                AsyncData(
                  PremiumAndTrial(
                    isPremium: false,
                    isTrial: false,
                    hasDiscountEntitlement: true,
                    trialDeadlineDate: null,
                    beginTrialDate: null,
                    discountEntitlementDeadlineDate: mockToday.subtract(const Duration(days: 1)),
                  ),
                ),
              ),
              isLinkedProvider.overrideWithValue(false),
              isJaLocaleProvider.overrideWithValue(true),
              isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
              durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate((widget) => widget is DiscountPriceDeadline),
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
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

        SharedPreferences.setMockInitialValues({
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
              premiumAndTrialProvider.overrideWithValue(
                AsyncData(
                  PremiumAndTrial(
                    isPremium: false,
                    isTrial: true,
                    hasDiscountEntitlement: false,
                    trialDeadlineDate: null,
                    beginTrialDate: null,
                    discountEntitlementDeadlineDate: null,
                  ),
                ),
              ),
              isLinkedProvider.overrideWithValue(false),
              isJaLocaleProvider.overrideWithValue(true),
              isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
              durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate((widget) => widget is RestDurationAnnouncementBar),
          findsOneWidget,
        );
      });

      testWidgets('#RecommendSignupAnnouncementBar', (WidgetTester tester) async {
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
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

        SharedPreferences.setMockInitialValues({
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
              premiumAndTrialProvider.overrideWithValue(
                AsyncData(
                  PremiumAndTrial(
                    isPremium: false,
                    isTrial: true,
                    hasDiscountEntitlement: false,
                    trialDeadlineDate: null,
                    beginTrialDate: null,
                    discountEntitlementDeadlineDate: null,
                  ),
                ),
              ),
              isLinkedProvider.overrideWithValue(false),
              isJaLocaleProvider.overrideWithValue(true),
              isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
              durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 400));

        expect(
          find.byWidgetPredicate((widget) => widget is RecommendSignupAnnouncementBar),
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
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

        SharedPreferences.setMockInitialValues({
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
              premiumAndTrialProvider.overrideWithValue(
                AsyncData(
                  PremiumAndTrial(
                    isPremium: false,
                    isTrial: true,
                    hasDiscountEntitlement: false,
                    trialDeadlineDate: mockToday.add(const Duration(days: 1)),
                    beginTrialDate: null,
                    discountEntitlementDeadlineDate: null,
                  ),
                ),
              ),
              isLinkedProvider.overrideWithValue(false),
              isJaLocaleProvider.overrideWithValue(true),
              isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
              durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pump();

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
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

        SharedPreferences.setMockInitialValues({
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
              premiumAndTrialProvider.overrideWithValue(
                AsyncData(
                  PremiumAndTrial(
                    isPremium: false,
                    isTrial: true,
                    hasDiscountEntitlement: false,
                    trialDeadlineDate: null,
                    beginTrialDate: null,
                    discountEntitlementDeadlineDate: null,
                  ),
                ),
              ),
              isLinkedProvider.overrideWithValue(true),
              isJaLocaleProvider.overrideWithValue(true),
              isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
              durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 400));

        expect(
          find.byWidgetPredicate((widget) => widget is EndedPillSheet),
          findsOneWidget,
        );
      });

      group("#PilllAdsAnnouncementBar", () {
        testWidgets('today is before 2022-08-10', (WidgetTester tester) async {
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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: false,
                      isTrial: false,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(PilllAds(
                    description: 'これは広告用のテキスト',
                    destinationURL: 'https://github.com/bannzai',
                    endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                    startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                    hexColor: '#111111',
                    imageURL: null,
                    // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                    version: "9999.9999.9999",
                  )),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 400));

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsNothing,
          );
        });
        testWidgets('today is 2022-08-10', (WidgetTester tester) async {
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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: false,
                      isTrial: false,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                      // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                      version: "9999.9999.9999",
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsOneWidget,
          );
        });
        testWidgets('version is nothing', (WidgetTester tester) async {
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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: false,
                      isTrial: false,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
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
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsNothing,
          );
        });
        testWidgets('version is greater than package version', (WidgetTester tester) async {
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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: false,
                      isTrial: false,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                      version: "9999.9999.9999",
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsOneWidget,
          );
        });
        testWidgets('version is less than package version', (WidgetTester tester) async {
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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: false,
                      isTrial: false,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                      version: "0.0.1",
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsNothing,
          );
        });
        testWidgets('version is equal to package version', (WidgetTester tester) async {
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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: false,
                      isTrial: false,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                      version: "1.0.0",
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsOneWidget,
          );
        });
        testWidgets('today is 2022-08-11', (WidgetTester tester) async {
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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: false,
                      isTrial: false,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                      // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                      version: "9999.9999.9999",
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsOneWidget,
          );
        });
        testWidgets('now is 2022-08-23T23:59:59', (WidgetTester tester) async {
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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: false,
                      isTrial: false,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                      // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                      version: "9999.9999.9999",
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsOneWidget,
          );
        });
        testWidgets('now is 2022-08-24T00:00:00', (WidgetTester tester) async {
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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: false,
                      isTrial: false,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                      // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                      version: "9999.9999.9999",
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

          expect(
            find.byWidgetPredicate((widget) => widget is PilllAdsAnnouncementBar),
            findsNothing,
          );
        });
      });

      group("#AffiliateAnnouncementBar", () {
        testWidgets('affiliate version < package version', (WidgetTester tester) async {
          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: today().subtract(const Duration(days: 1)),
            beginDate: today().subtract(
              const Duration(days: 25),
            ),
          );
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await runWithNetworkImages(() async {
            await tester.pumpWidget(
              ProviderScope(
                overrides: [
                  latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                  premiumAndTrialProvider.overrideWithValue(
                    AsyncData(
                      PremiumAndTrial(
                        isPremium: false,
                        isTrial: false,
                        hasDiscountEntitlement: true,
                        trialDeadlineDate: null,
                        beginTrialDate: null,
                        discountEntitlementDeadlineDate: null,
                      ),
                    ),
                  ),
                  isLinkedProvider.overrideWithValue(false),
                  isJaLocaleProvider.overrideWithValue(true),
                  isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                  durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                  packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                  affiliateProvider.overrideWith(
                    (ref) => Stream.value(
                      const Affiliate(
                        contents: [
                          AffiliateContent(imageURL: 'https://github.com/bannzai', destinationURL: 'https://github.com/bannzai'),
                        ],
                        // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが小さい場合は表示されない
                        version: "0.0.0",
                      ),
                    ),
                  ),
                  // PilllAdsの方が優先度は高いのでnullを流してテスト
                  pilllAdsProvider.overrideWith(
                    (ref) => Stream.value(null),
                  ),
                  sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                ],
                child: const MaterialApp(
                  home: Material(child: AnnouncementBar()),
                ),
              ),
            );
            await tester.pumpAndSettle(const Duration(milliseconds: 400));

            expect(
              find.byWidgetPredicate((widget) => widget is AffiliateAnnouncementBar),
              findsNothing,
            );
          });
        });
        testWidgets('affiliate version > package version', (WidgetTester tester) async {
          var pillSheet = PillSheet.create(
            PillSheetType.pillsheet_21,
            lastTakenDate: today().subtract(const Duration(days: 1)),
            beginDate: today().subtract(
              const Duration(days: 25),
            ),
          );
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await runWithNetworkImages(() async {
            await tester.pumpWidget(
              ProviderScope(
                overrides: [
                  latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                  premiumAndTrialProvider.overrideWithValue(
                    AsyncData(
                      PremiumAndTrial(
                        isPremium: false,
                        isTrial: false,
                        hasDiscountEntitlement: true,
                        trialDeadlineDate: null,
                        beginTrialDate: null,
                        discountEntitlementDeadlineDate: null,
                      ),
                    ),
                  ),
                  isLinkedProvider.overrideWithValue(false),
                  isJaLocaleProvider.overrideWithValue(true),
                  isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                  durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                  packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                  affiliateProvider.overrideWith(
                    (ref) => Stream.value(
                      const Affiliate(
                        contents: [
                          AffiliateContent(imageURL: 'https://github.com/bannzai', destinationURL: 'https://github.com/bannzai'),
                        ],
                        // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                        version: "9999.9999.9999",
                      ),
                    ),
                  ),
                  // PilllAdsの方が優先度は高いのでnullを流してテスト
                  pilllAdsProvider.overrideWith(
                    (ref) => Stream.value(null),
                  ),
                  sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                ],
                child: const MaterialApp(
                  home: Material(child: AnnouncementBar()),
                ),
              ),
            );
            await tester.pump();

            expect(
              find.byWidgetPredicate((widget) => widget is AffiliateAnnouncementBar),
              findsOneWidget,
            );
          });
        });
        testWidgets('pilll ads is exists', (WidgetTester tester) async {
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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await runWithNetworkImages(() async {
            await tester.pumpWidget(
              ProviderScope(
                overrides: [
                  latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                  premiumAndTrialProvider.overrideWithValue(
                    AsyncData(
                      PremiumAndTrial(
                        isPremium: false,
                        isTrial: false,
                        hasDiscountEntitlement: true,
                        trialDeadlineDate: null,
                        beginTrialDate: null,
                        discountEntitlementDeadlineDate: null,
                      ),
                    ),
                  ),
                  isLinkedProvider.overrideWithValue(false),
                  isJaLocaleProvider.overrideWithValue(true),
                  isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                  durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                  packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                  affiliateProvider.overrideWith(
                    (ref) => Stream.value(
                      const Affiliate(
                        contents: [
                          AffiliateContent(imageURL: 'https://github.com/bannzai', destinationURL: 'https://github.com/bannzai'),
                        ],
                        // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                        version: "9999.9999.9999",
                      ),
                    ),
                  ),
                  // PilllAdsの方が優先度は高いのでAffiliateAnnouncementBarは表示されない
                  pilllAdsProvider.overrideWith(
                    (ref) => Stream.value(
                      PilllAds(
                        description: 'これは広告用のテキスト',
                        destinationURL: 'https://github.com/bannzai',
                        endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                        startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                        hexColor: '#111111',
                        imageURL: null,
                        // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                        version: "9999.9999.9999",
                      ),
                    ),
                  ),
                  sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
                ],
                child: const MaterialApp(
                  home: Material(child: AnnouncementBar()),
                ),
              ),
            );
            await tester.pump();

            expect(
              find.byWidgetPredicate((widget) => widget is AffiliateAnnouncementBar),
              findsNothing,
            );
          });
        });
      });
    });

    group('for it is premium user', () {
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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: true,
                      isTrial: true,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                      // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                      version: "9999.9999.9999",
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: true,
                      isTrial: true,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                      // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                      version: "9999.9999.9999",
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: true,
                      isTrial: true,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                      // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                      version: "9999.9999.9999",
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: true,
                      isTrial: true,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                      // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                      version: "9999.9999.9999",
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: true,
                      isTrial: true,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                      // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                      version: "9999.9999.9999",
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

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
          final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

          SharedPreferences.setMockInitialValues({
            IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
            BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
          });
          final sharedPreferences = await SharedPreferences.getInstance();
          await tester.pumpWidget(
            ProviderScope(
              overrides: [
                latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
                premiumAndTrialProvider.overrideWithValue(
                  AsyncData(
                    PremiumAndTrial(
                      isPremium: true,
                      isTrial: true,
                      hasDiscountEntitlement: true,
                      trialDeadlineDate: null,
                      beginTrialDate: null,
                      discountEntitlementDeadlineDate: null,
                    ),
                  ),
                ),
                isLinkedProvider.overrideWithValue(false),
                isJaLocaleProvider.overrideWithValue(true),
                isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
                durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
                packageVersionProvider.overrideWith((ref) => Version(major: 1, minor: 0, patch: 0)),
                pilllAdsProvider.overrideWith(
                  (ref) => Stream.value(
                    PilllAds(
                      description: 'これは広告用のテキスト',
                      destinationURL: 'https://github.com/bannzai',
                      endDateTime: DateTime(2022, 8, 23, 23, 59, 59),
                      startDateTime: DateTime(2022, 8, 10, 0, 0, 0),
                      hexColor: '#111111',
                      imageURL: null,
                      // 広告を表示する場合はパッケージバージョンよりもAffiliateのバージョンが高い場合は表示される
                      version: "9999.9999.9999",
                    ),
                  ),
                ),
                sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
              ],
              child: const MaterialApp(
                home: Material(child: AnnouncementBar()),
              ),
            ),
          );
          await tester.pump();

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
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

        SharedPreferences.setMockInitialValues({
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
              premiumAndTrialProvider.overrideWithValue(
                AsyncData(
                  PremiumAndTrial(
                    isPremium: true,
                    isTrial: true,
                    hasDiscountEntitlement: true,
                    trialDeadlineDate: null,
                    beginTrialDate: null,
                    discountEntitlementDeadlineDate: null,
                  ),
                ),
              ),
              isLinkedProvider.overrideWithValue(false),
              isJaLocaleProvider.overrideWithValue(true),
              isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
              durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pump();

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
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

        SharedPreferences.setMockInitialValues({
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
              premiumAndTrialProvider.overrideWithValue(
                AsyncData(
                  PremiumAndTrial(
                    isPremium: true,
                    isTrial: false,
                    hasDiscountEntitlement: true,
                    trialDeadlineDate: null,
                    beginTrialDate: null,
                    discountEntitlementDeadlineDate: null,
                  ),
                ),
              ),
              isLinkedProvider.overrideWithValue(true),
              isJaLocaleProvider.overrideWithValue(true),
              isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
              durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pump();

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
        final pillSheetGroup = PillSheetGroup(pillSheetIDs: ["1"], pillSheets: [pillSheet], createdAt: now());

        SharedPreferences.setMockInitialValues({
          IntKey.totalCountOfActionForTakenPill: totalCountOfActionForTakenPillForLongTimeUser,
          BoolKey.recommendedSignupNotificationIsAlreadyShow: false,
        });
        final sharedPreferences = await SharedPreferences.getInstance();
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              latestPillSheetGroupProvider.overrideWith((ref) => Stream.value(pillSheetGroup)),
              premiumAndTrialProvider.overrideWithValue(
                AsyncData(
                  PremiumAndTrial(
                    isPremium: true,
                    isTrial: true,
                    hasDiscountEntitlement: true,
                    trialDeadlineDate: null,
                    beginTrialDate: null,
                    discountEntitlementDeadlineDate: null,
                  ),
                ),
              ),
              isLinkedProvider.overrideWithValue(true),
              isJaLocaleProvider.overrideWithValue(true),
              isOverDiscountDeadlineProvider.overrideWithProvider((param) => Provider.autoDispose((_) => false)),
              durationToDiscountPriceDeadline.overrideWithProvider((param) => Provider.autoDispose((_) => const Duration(seconds: 1000))),
              sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
            ],
            child: const MaterialApp(
              home: Material(child: AnnouncementBar()),
            ),
          ),
        );
        await tester.pump();

        expect(
          find.byWidgetPredicate((widget) => widget is EndedPillSheet),
          findsOneWidget,
        );
      });
    });
  });
}
