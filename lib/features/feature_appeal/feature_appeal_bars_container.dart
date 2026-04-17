import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/feature_appeal/alarm_kit/alarm_kit_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/appearance_mode_date/appearance_mode_date_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/calendar_diary/calendar_diary_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/creating_new_pillsheet/creating_new_pillsheet_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/critical_alert/critical_alert_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/future_schedule/future_schedule_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/health_care_integration/health_care_integration_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/menstruation/menstruation_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/quick_record/quick_record_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/record_pill/record_pill_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/reminder_notification_customize_word/reminder_notification_customize_word_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/rest_duration/rest_duration_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/today_pill_number/today_pill_number_announcement_bar.dart';
import 'package:pilll/provider/shared_preferences.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// FeatureAppeal の index ローテーション計算の起点となる epoch 日付。
/// 変更すると既存ユーザーの「今日表示される Bar」がずれる。
final DateTime _featureAppealEpoch = DateTime(2024, 1, 1);

/// AnnouncementBar 領域に表示する FeatureAppeal 専用コンテナ。
/// 候補 Bar のうち `daysBetween(epoch, today) % candidates.length` の 1 件だけを出す。
class FeatureAppealBarsContainer extends HookConsumerWidget {
  /// 未リリース機能を非表示にするフラグ。
  final bool appIsReleased;

  /// 親 (AnnouncementBar) が所有する「当日 dismiss 済み」フラグ。
  /// × ボタン押下で true にし、親の再ビルドでフォールバック表示に切り替える。
  final ValueNotifier<bool> dismissedToday;

  const FeatureAppealBarsContainer({super.key, required this.appIsReleased, required this.dismissedToday});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (dismissedToday.value) return const SizedBox.shrink();

    final sharedPreferences = ref.watch(sharedPreferencesProvider);

    final criticalAlertIsClosed = useState(sharedPreferences.getBool(BoolKey.criticalAlertFeatureAppealIsClosed) ?? false);
    final reminderNotificationCustomizeWordIsClosed =
        useState(sharedPreferences.getBool(BoolKey.reminderNotificationCustomizeWordFeatureAppealIsClosed) ?? false);
    final appearanceModeDateIsClosed = useState(sharedPreferences.getBool(BoolKey.appearanceModeDateFeatureAppealIsClosed) ?? false);
    final recordPillIsClosed = useState(sharedPreferences.getBool(BoolKey.recordPillFeatureAppealIsClosed) ?? false);
    final menstruationIsClosed = useState(sharedPreferences.getBool(BoolKey.menstruationFeatureAppealIsClosed) ?? false);
    final calendarDiaryIsClosed = useState(sharedPreferences.getBool(BoolKey.calendarDiaryFeatureAppealIsClosed) ?? false);
    final futureScheduleIsClosed = useState(sharedPreferences.getBool(BoolKey.futureScheduleFeatureAppealIsClosed) ?? false);
    final healthCareIntegrationIsClosed = useState(sharedPreferences.getBool(BoolKey.healthCareIntegrationFeatureAppealIsClosed) ?? false);
    final quickRecordIsClosed = useState(sharedPreferences.getBool(BoolKey.quickRecordFeatureAppealIsClosed) ?? false);
    final creatingNewPillSheetIsClosed = useState(sharedPreferences.getBool(BoolKey.creatingNewPillSheetFeatureAppealIsClosed) ?? false);
    final alarmKitIsClosed = useState(sharedPreferences.getBool(BoolKey.alarmKitFeatureAppealIsClosed) ?? false);
    final todayPillNumberIsClosed = useState(sharedPreferences.getBool(BoolKey.todayPillNumberFeatureAppealIsClosed) ?? false);
    final restDurationIsClosed = useState(sharedPreferences.getBool(BoolKey.restDurationFeatureAppealIsClosed) ?? false);

    useEffect(() {
      void markDismissedToday() {
        sharedPreferences.setString(StringKey.featureAppealLastDismissedDate, today().toIso8601String());
        dismissedToday.value = true;
      }

      void onCriticalAlert() {
        sharedPreferences.setBool(BoolKey.criticalAlertFeatureAppealIsClosed, criticalAlertIsClosed.value);
        if (criticalAlertIsClosed.value) markDismissedToday();
      }

      void onReminderNotificationCustomizeWord() {
        sharedPreferences.setBool(
          BoolKey.reminderNotificationCustomizeWordFeatureAppealIsClosed,
          reminderNotificationCustomizeWordIsClosed.value,
        );
        if (reminderNotificationCustomizeWordIsClosed.value) markDismissedToday();
      }

      void onAppearanceModeDate() {
        sharedPreferences.setBool(BoolKey.appearanceModeDateFeatureAppealIsClosed, appearanceModeDateIsClosed.value);
        if (appearanceModeDateIsClosed.value) markDismissedToday();
      }

      void onRecordPill() {
        sharedPreferences.setBool(BoolKey.recordPillFeatureAppealIsClosed, recordPillIsClosed.value);
        if (recordPillIsClosed.value) markDismissedToday();
      }

      void onMenstruation() {
        sharedPreferences.setBool(BoolKey.menstruationFeatureAppealIsClosed, menstruationIsClosed.value);
        if (menstruationIsClosed.value) markDismissedToday();
      }

      void onCalendarDiary() {
        sharedPreferences.setBool(BoolKey.calendarDiaryFeatureAppealIsClosed, calendarDiaryIsClosed.value);
        if (calendarDiaryIsClosed.value) markDismissedToday();
      }

      void onFutureSchedule() {
        sharedPreferences.setBool(BoolKey.futureScheduleFeatureAppealIsClosed, futureScheduleIsClosed.value);
        if (futureScheduleIsClosed.value) markDismissedToday();
      }

      void onHealthCareIntegration() {
        sharedPreferences.setBool(BoolKey.healthCareIntegrationFeatureAppealIsClosed, healthCareIntegrationIsClosed.value);
        if (healthCareIntegrationIsClosed.value) markDismissedToday();
      }

      void onQuickRecord() {
        sharedPreferences.setBool(BoolKey.quickRecordFeatureAppealIsClosed, quickRecordIsClosed.value);
        if (quickRecordIsClosed.value) markDismissedToday();
      }

      void onCreatingNewPillSheet() {
        sharedPreferences.setBool(BoolKey.creatingNewPillSheetFeatureAppealIsClosed, creatingNewPillSheetIsClosed.value);
        if (creatingNewPillSheetIsClosed.value) markDismissedToday();
      }

      void onAlarmKit() {
        sharedPreferences.setBool(BoolKey.alarmKitFeatureAppealIsClosed, alarmKitIsClosed.value);
        if (alarmKitIsClosed.value) markDismissedToday();
      }

      void onTodayPillNumber() {
        sharedPreferences.setBool(BoolKey.todayPillNumberFeatureAppealIsClosed, todayPillNumberIsClosed.value);
        if (todayPillNumberIsClosed.value) markDismissedToday();
      }

      void onRestDuration() {
        sharedPreferences.setBool(BoolKey.restDurationFeatureAppealIsClosed, restDurationIsClosed.value);
        if (restDurationIsClosed.value) markDismissedToday();
      }

      criticalAlertIsClosed.addListener(onCriticalAlert);
      reminderNotificationCustomizeWordIsClosed.addListener(onReminderNotificationCustomizeWord);
      appearanceModeDateIsClosed.addListener(onAppearanceModeDate);
      recordPillIsClosed.addListener(onRecordPill);
      menstruationIsClosed.addListener(onMenstruation);
      calendarDiaryIsClosed.addListener(onCalendarDiary);
      futureScheduleIsClosed.addListener(onFutureSchedule);
      healthCareIntegrationIsClosed.addListener(onHealthCareIntegration);
      quickRecordIsClosed.addListener(onQuickRecord);
      creatingNewPillSheetIsClosed.addListener(onCreatingNewPillSheet);
      alarmKitIsClosed.addListener(onAlarmKit);
      todayPillNumberIsClosed.addListener(onTodayPillNumber);
      restDurationIsClosed.addListener(onRestDuration);
      return () {
        criticalAlertIsClosed.removeListener(onCriticalAlert);
        reminderNotificationCustomizeWordIsClosed.removeListener(onReminderNotificationCustomizeWord);
        appearanceModeDateIsClosed.removeListener(onAppearanceModeDate);
        recordPillIsClosed.removeListener(onRecordPill);
        menstruationIsClosed.removeListener(onMenstruation);
        calendarDiaryIsClosed.removeListener(onCalendarDiary);
        futureScheduleIsClosed.removeListener(onFutureSchedule);
        healthCareIntegrationIsClosed.removeListener(onHealthCareIntegration);
        quickRecordIsClosed.removeListener(onQuickRecord);
        creatingNewPillSheetIsClosed.removeListener(onCreatingNewPillSheet);
        alarmKitIsClosed.removeListener(onAlarmKit);
        todayPillNumberIsClosed.removeListener(onTodayPillNumber);
        restDurationIsClosed.removeListener(onRestDuration);
      };
    }, [sharedPreferences]);

    final candidates = <Widget>[
      if (!criticalAlertIsClosed.value) CriticalAlertAnnouncementBar(isClosed: criticalAlertIsClosed),
      if (!reminderNotificationCustomizeWordIsClosed.value)
        ReminderNotificationCustomizeWordAnnouncementBar(isClosed: reminderNotificationCustomizeWordIsClosed),
      if (appIsReleased && !appearanceModeDateIsClosed.value) AppearanceModeDateAnnouncementBar(isClosed: appearanceModeDateIsClosed),
      if (!recordPillIsClosed.value) RecordPillAnnouncementBar(isClosed: recordPillIsClosed),
      if (!menstruationIsClosed.value) MenstruationAnnouncementBar(isClosed: menstruationIsClosed),
      if (!calendarDiaryIsClosed.value) CalendarDiaryAnnouncementBar(isClosed: calendarDiaryIsClosed),
      if (!futureScheduleIsClosed.value) FutureScheduleAnnouncementBar(isClosed: futureScheduleIsClosed),
      if (!healthCareIntegrationIsClosed.value) HealthCareIntegrationAnnouncementBar(isClosed: healthCareIntegrationIsClosed),
      if (!quickRecordIsClosed.value) QuickRecordAnnouncementBar(isClosed: quickRecordIsClosed),
      if (!creatingNewPillSheetIsClosed.value) CreatingNewPillSheetAnnouncementBar(isClosed: creatingNewPillSheetIsClosed),
      if (!alarmKitIsClosed.value) AlarmKitAnnouncementBar(isClosed: alarmKitIsClosed),
      if (!todayPillNumberIsClosed.value) TodayPillNumberAnnouncementBar(isClosed: todayPillNumberIsClosed),
      if (!restDurationIsClosed.value) RestDurationAnnouncementBar(isClosed: restDurationIsClosed),
    ];
    if (candidates.isEmpty) {
      return const SizedBox.shrink();
    }
    return Semantics(
      identifier: 'feature_appeal_bar',
      child: candidates[daysBetween(_featureAppealEpoch, today()) % candidates.length],
    );
  }

  /// 当日中に FeatureAppeal が × で閉じられたかどうか。SharedPreferences を直接読む。
  static bool wasDismissedToday({required SharedPreferences sharedPreferences}) {
    final featureAppealLastDismissedDate = sharedPreferences.getString(StringKey.featureAppealLastDismissedDate);
    if (featureAppealLastDismissedDate == null) return false;
    final parsed = DateTime.tryParse(featureAppealLastDismissedDate);
    if (parsed == null) return false;
    return isSameDay(parsed, today());
  }

  /// AnnouncementBar の `_body()` で「FeatureAppeal を出すかフォールバックに進むか」を事前判定するためのヘルパー。
  /// SharedPreferences を直接読むため Container build 前に呼べる。
  static bool hasAnyCandidate({
    required SharedPreferences sharedPreferences,
    required bool appIsReleased,
  }) {
    return [
      !(sharedPreferences.getBool(BoolKey.criticalAlertFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.reminderNotificationCustomizeWordFeatureAppealIsClosed) ?? false),
      appIsReleased && !(sharedPreferences.getBool(BoolKey.appearanceModeDateFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.recordPillFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.menstruationFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.calendarDiaryFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.futureScheduleFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.healthCareIntegrationFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.quickRecordFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.creatingNewPillSheetFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.alarmKitFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.todayPillNumberFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.restDurationFeatureAppealIsClosed) ?? false),
    ].any((available) => available);
  }
}
