import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/features/feature_appeal/appearance_mode_date/appearance_mode_date_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/calendar_diary/calendar_diary_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/critical_alert/critical_alert_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/feature_appeal_bars_container.dart';
import 'package:pilll/features/feature_appeal/future_schedule/future_schedule_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/health_care_integration/health_care_integration_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/menstruation/menstruation_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/record_pill/record_pill_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/reminder_notification_customize_word/reminder_notification_customize_word_announcement_bar.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/mock.mocks.dart';

/// FeatureAppealBarsContainer 内部と同じ epoch。テストで index を予測するために使う。
final DateTime _featureAppealEpoch = DateTime(2024, 1, 1);

void main() {
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

    test('8 機能すべての isClosed key を true にする → false を返す', () async {
      SharedPreferences.setMockInitialValues({
        BoolKey.criticalAlertFeatureAppealIsClosed: true,
        BoolKey.reminderNotificationCustomizeWordFeatureAppealIsClosed: true,
        BoolKey.appearanceModeDateFeatureAppealIsClosed: true,
        BoolKey.recordPillFeatureAppealIsClosed: true,
        BoolKey.menstruationFeatureAppealIsClosed: true,
        BoolKey.calendarDiaryFeatureAppealIsClosed: true,
        BoolKey.futureScheduleFeatureAppealIsClosed: true,
        BoolKey.healthCareIntegrationFeatureAppealIsClosed: true,
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
    /// 候補リスト (本実装と同じ並び順) のうち、appIsReleased=true で全 8 件存在する状態を想定。
    /// テストでは today を任意に固定して daysBetween(epoch, today) % 8 が想定の Bar に一致するかを確認する。
    Type expectedBarTypeForIndex(int index) {
      return [
        CriticalAlertAnnouncementBar,
        ReminderNotificationCustomizeWordAnnouncementBar,
        AppearanceModeDateAnnouncementBar,
        RecordPillAnnouncementBar,
        MenstruationAnnouncementBar,
        CalendarDiaryAnnouncementBar,
        FutureScheduleAnnouncementBar,
        HealthCareIntegrationAnnouncementBar,
      ][index];
    }

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

      // epoch と同日 → daysBetween=0 → index 0 → CriticalAlertAnnouncementBar
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
        'criticalAlert を dismiss 済み → 残り 7 候補のうち index 0 (本来は criticalAlert) は表示されない',
        (tester) async {
      final mockTodayRepository = MockTodayService();
      when(mockTodayRepository.now()).thenReturn(_featureAppealEpoch);
      todayRepository = mockTodayRepository;

      SharedPreferences.setMockInitialValues({
        BoolKey.criticalAlertFeatureAppealIsClosed: true,
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

      // criticalAlert は除外。残り 7 候補で daysBetween=0 → index 0 = ReminderNotificationCustomizeWord
      expect(find.byType(CriticalAlertAnnouncementBar), findsNothing);
      expect(find.byType(ReminderNotificationCustomizeWordAnnouncementBar),
          findsOneWidget);
    });

    testWidgets(
        'appIsReleased=false → AppearanceModeDateAnnouncementBar が候補から除外される',
        (tester) async {
      final mockTodayRepository = MockTodayService();
      // 通常 epoch から 2 日後なら index 2 (AppearanceModeDate) になるはず。除外されると 2 番目以降がずれる。
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

      // appearance_mode_date が除外されているので、その日には別の Bar が表示される
      expect(find.byType(AppearanceModeDateAnnouncementBar), findsNothing);
      // 7 候補の中で index 2 = RecordPillAnnouncementBar (本来は AppearanceModeDate がいた位置)
      expect(find.byType(RecordPillAnnouncementBar), findsOneWidget);
    });

    testWidgets('8 機能全 dismiss → SizedBox.shrink が表示される', (tester) async {
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

      // 全 8 個の Bar が表示されないことを確認
      expect(find.byType(CriticalAlertAnnouncementBar), findsNothing);
      expect(find.byType(ReminderNotificationCustomizeWordAnnouncementBar),
          findsNothing);
      expect(find.byType(AppearanceModeDateAnnouncementBar), findsNothing);
      expect(find.byType(RecordPillAnnouncementBar), findsNothing);
      expect(find.byType(MenstruationAnnouncementBar), findsNothing);
      expect(find.byType(CalendarDiaryAnnouncementBar), findsNothing);
      expect(find.byType(FutureScheduleAnnouncementBar), findsNothing);
      expect(find.byType(HealthCareIntegrationAnnouncementBar), findsNothing);
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
