import 'package:pilll/analytics.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_state.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar_store.dart';
import 'package:pilll/domain/record/components/notification_bar/premium_trial_guide.dart';
import 'package:pilll/domain/record/components/notification_bar/premium_trial_limit.dart';
import 'package:pilll/domain/record/components/notification_bar/recommend_signup.dart';
import 'package:pilll/domain/record/components/notification_bar/rest_duration.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/service/day.dart';
import 'package:pilll/util/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/mock.mocks.dart';

class FakeState extends Fake implements NotificationBarState {}

void main() {
  final totalCountOfActionForTakenPillForLongTimeUser = 14;
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
  group('notification bar appearance content type', () {
    testWidgets('#RestDurationNotificationBar', (WidgetTester tester) async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime(2021, 04, 29);

      when(mockTodayRepository.today()).thenReturn(today);
      todayRepository = mockTodayRepository;

      var pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      pillSheet = pillSheet.copyWith(
        lastTakenDate: today,
        beginingDate: today.subtract(
// NOTE: Into rest duration and notification duration
          Duration(days: 25),
        ),
      );
      var state = NotificationBarState(
        pillSheet: pillSheet,
        totalCountOfActionForTakenPill:
            totalCountOfActionForTakenPillForLongTimeUser,
        isPremium: false,
        isTrial: false,
        isLinkedLoginProvider: false,
        premiumTrialGuideNotificationIsClosed: false,
        recommendedSignupNotificationIsAlreadyShow: false,
        trialDeadlineDate: null,
      );

      final recordPageState = RecordPageState(entity: pillSheet);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notificationBarStateProvider
                .overrideWithProvider((ref, param) => state),
          ],
          child: MaterialApp(
            home: NotificationBar(recordPageState),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byWidgetPredicate(
            (widget) => widget is RestDurationNotificationBar),
        findsOneWidget,
      );
    });

    testWidgets('#RecommendSignupNotificationBar', (WidgetTester tester) async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime(2021, 04, 29);

      when(mockTodayRepository.today()).thenReturn(today);
      todayRepository = mockTodayRepository;

      var pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      pillSheet = pillSheet.copyWith(
        lastTakenDate: today,
        beginingDate: today.subtract(
// NOTE: Not into rest duration and notification duration
          Duration(days: 10),
        ),
      );
      var state = NotificationBarState(
        pillSheet: pillSheet,
        totalCountOfActionForTakenPill:
            totalCountOfActionForTakenPillForLongTimeUser,
        isPremium: false,
        isTrial: false,
        isLinkedLoginProvider: false,
        premiumTrialGuideNotificationIsClosed: false,
        recommendedSignupNotificationIsAlreadyShow: false,
        trialDeadlineDate: null,
      );

      final recordPageState = RecordPageState(entity: pillSheet);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notificationBarStoreProvider.overrideWithProvider(
                (ref, param) => MockNotificationBarStateStore()),
            notificationBarStateProvider
                .overrideWithProvider((ref, param) => state),
          ],
          child: MaterialApp(
            home: Material(child: NotificationBar(recordPageState)),
          ),
        ),
      );
      await tester.pumpAndSettle(Duration(milliseconds: 400));

      expect(
        find.byWidgetPredicate(
            (widget) => widget is RecommendSignupNotificationBar),
        findsOneWidget,
      );
    });
    testWidgets('#PremiumTrialGuideNotificationBar',
        (WidgetTester tester) async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime(2021, 04, 29);

      when(mockTodayRepository.today()).thenReturn(today);
      todayRepository = mockTodayRepository;

      var pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      pillSheet = pillSheet.copyWith(
        lastTakenDate: today,
        beginingDate: today.subtract(
// NOTE: Not into rest duration and notification duration
          Duration(days: 10),
        ),
      );
      var state = NotificationBarState(
        pillSheet: pillSheet,
        totalCountOfActionForTakenPill:
            totalCountOfActionForTakenPillForLongTimeUser,
        isPremium: false,
        isTrial: false,
        isLinkedLoginProvider: true,
        premiumTrialGuideNotificationIsClosed: false,
        recommendedSignupNotificationIsAlreadyShow: false,
        trialDeadlineDate: null,
      );

      final recordPageState = RecordPageState(entity: pillSheet);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notificationBarStateProvider
                .overrideWithProvider((ref, param) => state),
            notificationBarStoreProvider.overrideWithProvider(
                (ref, param) => MockNotificationBarStateStore()),
          ],
          child: MaterialApp(
            home: Material(child: NotificationBar(recordPageState)),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byWidgetPredicate(
            (widget) => widget is PremiumTrialGuideNotificationBar),
        findsOneWidget,
      );
    });
    testWidgets('#PremiumTrialLimitNotificationBar',
        (WidgetTester tester) async {
      final mockTodayRepository = MockTodayService();
      final today = DateTime(2021, 04, 29);
      final now = today;

      when(mockTodayRepository.today()).thenReturn(today);
      when(mockTodayRepository.now()).thenReturn(now);
      todayRepository = mockTodayRepository;

      var pillSheet = PillSheet.create(PillSheetType.pillsheet_21);
      pillSheet = pillSheet.copyWith(
        lastTakenDate: today,
        beginingDate: today.subtract(
// NOTE: Not into rest duration and notification duration
          Duration(days: 10),
        ),
      );
      var state = NotificationBarState(
        pillSheet: pillSheet,
        totalCountOfActionForTakenPill:
            totalCountOfActionForTakenPillForLongTimeUser,
        isPremium: false,
        isTrial: true,
        isLinkedLoginProvider: true,
        premiumTrialGuideNotificationIsClosed: false,
        recommendedSignupNotificationIsAlreadyShow: false,
        trialDeadlineDate: today.add(Duration(days: 1)),
      );

      final recordPageState = RecordPageState(entity: pillSheet);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notificationBarStateProvider
                .overrideWithProvider((ref, param) => state),
            notificationBarStoreProvider.overrideWithProvider(
                (ref, param) => MockNotificationBarStateStore()),
          ],
          child: MaterialApp(
            home: Material(child: NotificationBar(recordPageState)),
          ),
        ),
      );
      await tester.pump();

      expect(
        find.byWidgetPredicate(
            (widget) => widget is PremiumTrialLimitNotificationBar),
        findsOneWidget,
      );
    });
  });
}
