import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/features/feature_appeal/alarm_kit/alarm_kit_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/appearance_mode_date/appearance_mode_date_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/calendar_diary/calendar_diary_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/creating_new_pillsheet/creating_new_pillsheet_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/critical_alert/critical_alert_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/feature_appeal_bars_container.dart';
import 'package:pilll/features/feature_appeal/future_schedule/future_schedule_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/health_care_integration/health_care_integration_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/menstruation/menstruation_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/quick_record/quick_record_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/record_pill/record_pill_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/reminder_notification_customize_word/reminder_notification_customize_word_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/rest_duration/rest_duration_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/today_pill_number/today_pill_number_announcement_bar.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/fake.dart';
import '../../helper/mock.mocks.dart';

/// FeatureAppealBarsContainer 内部と同じ epoch。テストで index を予測するために使う。
final DateTime _featureAppealEpoch = DateTime(2024, 1, 1);

void main() {
  setUp(() {
    // 表示時に feature_appeal_bar_shown を送るため、Firebase 未初期化のテストで例外にならないよう Fake に差し替える
    analytics = FakeAnalytics();
  });

  group('#weightedRotationOrder', () {
    test('重み [A:3, B:1, C:2] → 周回ごとに候補を散らした [A, B, C, A, C, A] になる', () {
      expect(
        weightedRotationOrder(weightedCandidates: [(candidate: 'A', weight: 3), (candidate: 'B', weight: 1), (candidate: 'C', weight: 2)]),
        ['A', 'B', 'C', 'A', 'C', 'A'],
      );
    });

    test('全候補が重み 1 → 候補の並びそのまま (従来の均等ローテーションと同じ)', () {
      expect(
        weightedRotationOrder(weightedCandidates: [(candidate: 'A', weight: 1), (candidate: 'B', weight: 1), (candidate: 'C', weight: 1)]),
        ['A', 'B', 'C'],
      );
    });

    test('候補が空 → 空リスト', () {
      expect(weightedRotationOrder<String>(weightedCandidates: []), isEmpty);
    });

    test('表示順の長さは重みの合計に一致し、各候補は重みの回数だけ現れる', () {
      final order = weightedRotationOrder(weightedCandidates: [(candidate: 'A', weight: 3), (candidate: 'B', weight: 1), (candidate: 'C', weight: 2)]);
      expect(order.length, 6);
      expect(order.where((candidate) => candidate == 'A').length, 3);
      expect(order.where((candidate) => candidate == 'B').length, 1);
      expect(order.where((candidate) => candidate == 'C').length, 2);
    });
  });

  group('#hasAnyCandidate', () {
    test('prefs 空 → 候補があるので true を返す', () async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      expect(
        FeatureAppealBarsContainer.hasAnyCandidate(
          sharedPreferences: sharedPreferences,
          appIsReleased: true,
        ),
        isTrue,
      );
    });

    test('13 機能すべての isClosed key を true にする → false を返す', () async {
      SharedPreferences.setMockInitialValues({
        BoolKey.criticalAlertFeatureAppealIsClosed: true,
        BoolKey.reminderNotificationCustomizeWordFeatureAppealIsClosed: true,
        BoolKey.appearanceModeDateFeatureAppealIsClosed: true,
        BoolKey.recordPillFeatureAppealIsClosed: true,
        BoolKey.menstruationFeatureAppealIsClosed: true,
        BoolKey.calendarDiaryFeatureAppealIsClosed: true,
        BoolKey.futureScheduleFeatureAppealIsClosed: true,
        BoolKey.healthCareIntegrationFeatureAppealIsClosed: true,
        BoolKey.quickRecordFeatureAppealIsClosed: true,
        BoolKey.creatingNewPillSheetFeatureAppealIsClosed: true,
        BoolKey.alarmKitFeatureAppealIsClosed: true,
        BoolKey.todayPillNumberFeatureAppealIsClosed: true,
        BoolKey.restDurationFeatureAppealIsClosed: true,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      expect(
        FeatureAppealBarsContainer.hasAnyCandidate(
          sharedPreferences: sharedPreferences,
          appIsReleased: true,
        ),
        isFalse,
      );
    });

    test(
        'appIsReleased=false かつ appearanceModeDate のみ未 dismiss で他全 dismiss → false (appIsReleased ゲートが効く)',
        () async {
      SharedPreferences.setMockInitialValues({
        BoolKey.criticalAlertFeatureAppealIsClosed: true,
        BoolKey.reminderNotificationCustomizeWordFeatureAppealIsClosed: true,
        BoolKey.appearanceModeDateFeatureAppealIsClosed: false,
        BoolKey.recordPillFeatureAppealIsClosed: true,
        BoolKey.menstruationFeatureAppealIsClosed: true,
        BoolKey.calendarDiaryFeatureAppealIsClosed: true,
        BoolKey.futureScheduleFeatureAppealIsClosed: true,
        BoolKey.healthCareIntegrationFeatureAppealIsClosed: true,
        BoolKey.quickRecordFeatureAppealIsClosed: true,
        BoolKey.creatingNewPillSheetFeatureAppealIsClosed: true,
        BoolKey.alarmKitFeatureAppealIsClosed: true,
        BoolKey.todayPillNumberFeatureAppealIsClosed: true,
        BoolKey.restDurationFeatureAppealIsClosed: true,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      expect(
        FeatureAppealBarsContainer.hasAnyCandidate(
          sharedPreferences: sharedPreferences,
          appIsReleased: false,
        ),
        isFalse,
      );
    });

    test(
        'appIsReleased=true かつ appearanceModeDate のみ未 dismiss で他全 dismiss → true',
        () async {
      SharedPreferences.setMockInitialValues({
        BoolKey.criticalAlertFeatureAppealIsClosed: true,
        BoolKey.reminderNotificationCustomizeWordFeatureAppealIsClosed: true,
        BoolKey.appearanceModeDateFeatureAppealIsClosed: false,
        BoolKey.recordPillFeatureAppealIsClosed: true,
        BoolKey.menstruationFeatureAppealIsClosed: true,
        BoolKey.calendarDiaryFeatureAppealIsClosed: true,
        BoolKey.futureScheduleFeatureAppealIsClosed: true,
        BoolKey.healthCareIntegrationFeatureAppealIsClosed: true,
        BoolKey.quickRecordFeatureAppealIsClosed: true,
        BoolKey.creatingNewPillSheetFeatureAppealIsClosed: true,
        BoolKey.alarmKitFeatureAppealIsClosed: true,
        BoolKey.todayPillNumberFeatureAppealIsClosed: true,
        BoolKey.restDurationFeatureAppealIsClosed: true,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      expect(
        FeatureAppealBarsContainer.hasAnyCandidate(
          sharedPreferences: sharedPreferences,
          appIsReleased: true,
        ),
        isTrue,
      );
    });
  });

  group('#wasDismissedToday', () {
    test('prefs 空 → false を返す', () async {
      final mockTodayRepository = MockTodayService();
      when(mockTodayRepository.now()).thenReturn(DateTime(2024, 1, 1));
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      expect(
        FeatureAppealBarsContainer.wasDismissedToday(
            sharedPreferences: sharedPreferences),
        isFalse,
      );
    });

    test('今日の日付が保存済み → true を返す', () async {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime(2024, 4, 10);
      when(mockTodayRepository.now()).thenReturn(mockToday);
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({
        StringKey.featureAppealLastDismissedDate: mockToday.toIso8601String(),
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      expect(
        FeatureAppealBarsContainer.wasDismissedToday(
            sharedPreferences: sharedPreferences),
        isTrue,
      );
    });

    test('昨日の日付が保存済み → false を返す', () async {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime(2024, 4, 10);
      when(mockTodayRepository.now()).thenReturn(mockToday);
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({
        StringKey.featureAppealLastDismissedDate:
            mockToday.subtract(const Duration(days: 1)).toIso8601String(),
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      expect(
        FeatureAppealBarsContainer.wasDismissedToday(
            sharedPreferences: sharedPreferences),
        isFalse,
      );
    });
  });

  group('#FeatureAppealBarsContainer', () {
    /// 本実装と同じ候補の並び順・重みで組んだ表示順 (weightedRotationOrder) のうち、appIsReleased=true で全件存在する状態を想定。
    /// CriticalAlert / AlarmKit は Platform.isIOS=true の時だけ候補に含まれる。
    /// テストでは today を任意に固定して daysBetween(epoch, today) % 表示順の長さ が想定の Bar に一致するかを確認する。
    Type expectedBarTypeForIndex(int index) {
      return weightedRotationOrder(
        weightedCandidates: [
          (candidate: QuickRecordAnnouncementBar, weight: FeatureAppealBarWeight.highConversion),
          (candidate: ReminderNotificationCustomizeWordAnnouncementBar, weight: FeatureAppealBarWeight.noConversion),
          (candidate: RestDurationAnnouncementBar, weight: FeatureAppealBarWeight.noConversion),
          if (Platform.isIOS) (candidate: CriticalAlertAnnouncementBar, weight: FeatureAppealBarWeight.noConversion),
          (candidate: AppearanceModeDateAnnouncementBar, weight: FeatureAppealBarWeight.someConversion),
          (candidate: RecordPillAnnouncementBar, weight: FeatureAppealBarWeight.noConversion),
          (candidate: MenstruationAnnouncementBar, weight: FeatureAppealBarWeight.someConversion),
          (candidate: CalendarDiaryAnnouncementBar, weight: FeatureAppealBarWeight.noConversion),
          (candidate: FutureScheduleAnnouncementBar, weight: FeatureAppealBarWeight.someConversion),
          (candidate: HealthCareIntegrationAnnouncementBar, weight: FeatureAppealBarWeight.highConversion),
          (candidate: CreatingNewPillSheetAnnouncementBar, weight: FeatureAppealBarWeight.noConversion),
          if (Platform.isIOS) (candidate: AlarmKitAnnouncementBar, weight: FeatureAppealBarWeight.highConversion),
          (candidate: TodayPillNumberAnnouncementBar, weight: FeatureAppealBarWeight.noConversion),
        ],
      )[index];
    }

    testWidgets('2 周目 (全候補を一巡した翌日) は重み 2 以上の候補だけが表示される', (tester) async {
      final mockTodayRepository = MockTodayService();
      // 非 iOS で 1 周目は 11 候補。epoch+11 日 → 2 周目の先頭 = 重み 3 の QuickRecord
      when(mockTodayRepository.now()).thenReturn(_featureAppealEpoch.add(const Duration(days: 11)));
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          ],
          child: MaterialApp(
            home: Material(
              child: FeatureAppealBarsContainer(appIsReleased: true, dismissedToday: ValueNotifier(false)),
            ),
          ),
        ),
      );

      expect(find.byType(expectedBarTypeForIndex(11)), findsOneWidget);
      expect(find.byType(QuickRecordAnnouncementBar), findsOneWidget);
      expect(find.byType(ReminderNotificationCustomizeWordAnnouncementBar), findsNothing);
    });

    testWidgets('3 周目の末尾 (表示順の最終日) は重み 3 の HealthCareIntegration が表示され、翌日は先頭に戻る', (tester) async {
      final mockTodayRepository = MockTodayService();
      // 非 iOS: 1 周目 11 + 2 周目 5 (QuickRecord / AppearanceModeDate / Menstruation / FutureSchedule / HealthCare) + 3 周目 2 (QuickRecord / HealthCare) = 18
      when(mockTodayRepository.now()).thenReturn(_featureAppealEpoch.add(const Duration(days: 17)));
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          ],
          child: MaterialApp(
            home: Material(
              child: FeatureAppealBarsContainer(appIsReleased: true, dismissedToday: ValueNotifier(false)),
            ),
          ),
        ),
      );
      expect(find.byType(expectedBarTypeForIndex(17)), findsOneWidget);
      expect(find.byType(HealthCareIntegrationAnnouncementBar), findsOneWidget);

      when(mockTodayRepository.now()).thenReturn(_featureAppealEpoch.add(const Duration(days: 18)));
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          ],
          child: MaterialApp(
            home: Material(
              child: FeatureAppealBarsContainer(appIsReleased: true, dismissedToday: ValueNotifier(false)),
            ),
          ),
        ),
      );
      expect(find.byType(expectedBarTypeForIndex(0)), findsOneWidget);
      expect(find.byType(QuickRecordAnnouncementBar), findsOneWidget);
    });

    testWidgets('prefs 空 + appIsReleased=true → 当日 index に対応する Bar が表示される',
        (tester) async {
      final mockTodayRepository = MockTodayService();
      final mockToday = DateTime(2024, 1, 1);
      when(mockTodayRepository.now()).thenReturn(mockToday);
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          ],
          child: MaterialApp(
            home: Material(
              child: FeatureAppealBarsContainer(
                  appIsReleased: true, dismissedToday: ValueNotifier(false)),
            ),
          ),
        ),
      );

      // epoch と同日 → daysBetween=0 → index 0 → QuickRecordAnnouncementBar
      expect(find.byType(expectedBarTypeForIndex(0)), findsOneWidget);
    });

    testWidgets('today を翌日に進める → index が +1 ずれて別の Bar が表示される', (tester) async {
      final mockTodayRepository = MockTodayService();
      when(mockTodayRepository.now())
          .thenReturn(_featureAppealEpoch.add(const Duration(days: 1)));
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          ],
          child: MaterialApp(
            home: Material(
              child: FeatureAppealBarsContainer(
                  appIsReleased: true, dismissedToday: ValueNotifier(false)),
            ),
          ),
        ),
      );

      // daysBetween=1 → index 1 → ReminderNotificationCustomizeWordAnnouncementBar
      expect(find.byType(expectedBarTypeForIndex(1)), findsOneWidget);
    });

    testWidgets(
        'ReminderNotificationCustomizeWord を dismiss 済み → 当日 index には別の Bar が表示される',
        (tester) async {
      // 本テストは macOS/Linux で実行される前提で Platform.isIOS=false となり、
      // CriticalAlert / AlarmKit は初めから候補に含まれない。そのため dismiss の効果検証は
      // Reminder を対象にする。
      final mockTodayRepository = MockTodayService();
      when(mockTodayRepository.now()).thenReturn(_featureAppealEpoch);
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({
        BoolKey.reminderNotificationCustomizeWordFeatureAppealIsClosed: true,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          ],
          child: MaterialApp(
            home: Material(
              child: FeatureAppealBarsContainer(
                  appIsReleased: true, dismissedToday: ValueNotifier(false)),
            ),
          ),
        ),
      );

      // Reminder は除外。Platform.isIOS=false の候補先頭は QuickRecord なので、
      // daysBetween=0 → index 0 = QuickRecord がそのまま残る。
      expect(find.byType(ReminderNotificationCustomizeWordAnnouncementBar),
          findsNothing);
      expect(find.byType(QuickRecordAnnouncementBar), findsOneWidget);
    });

    testWidgets(
        'appIsReleased=false → AppearanceModeDateAnnouncementBar が候補から除外される',
        (tester) async {
      final mockTodayRepository = MockTodayService();
      when(mockTodayRepository.now())
          .thenReturn(_featureAppealEpoch.add(const Duration(days: 2)));
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          ],
          child: MaterialApp(
            home: Material(
              child: FeatureAppealBarsContainer(
                  appIsReleased: false, dismissedToday: ValueNotifier(false)),
            ),
          ),
        ),
      );

      // Platform.isIOS=false (macOS/Linux) かつ appIsReleased=false で候補は 10 件。
      // 1 周目の並び順: QuickRecord / Reminder / RestDuration / RecordPill / Menstruation / ...
      // epoch+2 日 → daysBetween=2 → index 2 = RestDuration。
      expect(find.byType(AppearanceModeDateAnnouncementBar), findsNothing);
      expect(find.byType(RestDurationAnnouncementBar), findsOneWidget);
    });

    testWidgets('13 機能全 dismiss → SizedBox.shrink が表示される', (tester) async {
      final mockTodayRepository = MockTodayService();
      when(mockTodayRepository.now()).thenReturn(_featureAppealEpoch);
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({
        BoolKey.criticalAlertFeatureAppealIsClosed: true,
        BoolKey.reminderNotificationCustomizeWordFeatureAppealIsClosed: true,
        BoolKey.appearanceModeDateFeatureAppealIsClosed: true,
        BoolKey.recordPillFeatureAppealIsClosed: true,
        BoolKey.menstruationFeatureAppealIsClosed: true,
        BoolKey.calendarDiaryFeatureAppealIsClosed: true,
        BoolKey.futureScheduleFeatureAppealIsClosed: true,
        BoolKey.healthCareIntegrationFeatureAppealIsClosed: true,
        BoolKey.quickRecordFeatureAppealIsClosed: true,
        BoolKey.creatingNewPillSheetFeatureAppealIsClosed: true,
        BoolKey.alarmKitFeatureAppealIsClosed: true,
        BoolKey.todayPillNumberFeatureAppealIsClosed: true,
        BoolKey.restDurationFeatureAppealIsClosed: true,
      });
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          ],
          child: MaterialApp(
            home: Material(
              child: FeatureAppealBarsContainer(
                  appIsReleased: true, dismissedToday: ValueNotifier(false)),
            ),
          ),
        ),
      );

      // 全 13 個の Bar が表示されないことを確認
      expect(find.byType(CriticalAlertAnnouncementBar), findsNothing);
      expect(find.byType(ReminderNotificationCustomizeWordAnnouncementBar),
          findsNothing);
      expect(find.byType(AppearanceModeDateAnnouncementBar), findsNothing);
      expect(find.byType(RecordPillAnnouncementBar), findsNothing);
      expect(find.byType(MenstruationAnnouncementBar), findsNothing);
      expect(find.byType(CalendarDiaryAnnouncementBar), findsNothing);
      expect(find.byType(FutureScheduleAnnouncementBar), findsNothing);
      expect(find.byType(HealthCareIntegrationAnnouncementBar), findsNothing);
      expect(find.byType(QuickRecordAnnouncementBar), findsNothing);
      expect(find.byType(CreatingNewPillSheetAnnouncementBar), findsNothing);
      expect(find.byType(AlarmKitAnnouncementBar), findsNothing);
      expect(find.byType(TodayPillNumberAnnouncementBar), findsNothing);
      expect(find.byType(RestDurationAnnouncementBar), findsNothing);
    });

    testWidgets('dismissedToday=true → 候補があっても SizedBox.shrink が表示される',
        (tester) async {
      final mockTodayRepository = MockTodayService();
      when(mockTodayRepository.now()).thenReturn(_featureAppealEpoch);
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          ],
          child: MaterialApp(
            home: Material(
              child: FeatureAppealBarsContainer(
                  appIsReleased: true, dismissedToday: ValueNotifier(true)),
            ),
          ),
        ),
      );

      expect(find.byType(CriticalAlertAnnouncementBar), findsNothing);
      expect(find.byType(ReminderNotificationCustomizeWordAnnouncementBar),
          findsNothing);
    });
  });
}
