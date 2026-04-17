import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/atoms/color.dart';
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

/// FeatureAppeal の全 AnnouncementBar Widget を 1 画面に並べて確認するページ。
/// 開発者オプションからアクセスし、日次ローテーションや dismiss 状態に依存せず
/// 全 Bar の表示 (文言・アイコン・タップ遷移) を横断的に検証する用途。
class FeatureAppealAnnouncementBarListPage extends HookWidget {
  const FeatureAppealAnnouncementBarListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final criticalAlertClosed = useState(false);
    final reminderNotificationCustomizeWordClosed = useState(false);
    final appearanceModeDateClosed = useState(false);
    final recordPillClosed = useState(false);
    final menstruationClosed = useState(false);
    final calendarDiaryClosed = useState(false);
    final futureScheduleClosed = useState(false);
    final healthCareIntegrationClosed = useState(false);
    final quickRecordClosed = useState(false);
    final creatingNewPillSheetClosed = useState(false);
    final alarmKitClosed = useState(false);
    final todayPillNumberClosed = useState(false);
    final restDurationClosed = useState(false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('FeatureAppeal AnnouncementBar 一覧'),
        backgroundColor: AppColors.background,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (!criticalAlertClosed.value) CriticalAlertAnnouncementBar(isClosed: criticalAlertClosed),
          const SizedBox(height: 8),
          if (!reminderNotificationCustomizeWordClosed.value)
            ReminderNotificationCustomizeWordAnnouncementBar(isClosed: reminderNotificationCustomizeWordClosed),
          const SizedBox(height: 8),
          if (!appearanceModeDateClosed.value) AppearanceModeDateAnnouncementBar(isClosed: appearanceModeDateClosed),
          const SizedBox(height: 8),
          if (!recordPillClosed.value) RecordPillAnnouncementBar(isClosed: recordPillClosed),
          const SizedBox(height: 8),
          if (!menstruationClosed.value) MenstruationAnnouncementBar(isClosed: menstruationClosed),
          const SizedBox(height: 8),
          if (!calendarDiaryClosed.value) CalendarDiaryAnnouncementBar(isClosed: calendarDiaryClosed),
          const SizedBox(height: 8),
          if (!futureScheduleClosed.value) FutureScheduleAnnouncementBar(isClosed: futureScheduleClosed),
          const SizedBox(height: 8),
          if (!healthCareIntegrationClosed.value) HealthCareIntegrationAnnouncementBar(isClosed: healthCareIntegrationClosed),
          const SizedBox(height: 8),
          if (!quickRecordClosed.value) QuickRecordAnnouncementBar(isClosed: quickRecordClosed),
          const SizedBox(height: 8),
          if (!creatingNewPillSheetClosed.value) CreatingNewPillSheetAnnouncementBar(isClosed: creatingNewPillSheetClosed),
          const SizedBox(height: 8),
          if (!alarmKitClosed.value) AlarmKitAnnouncementBar(isClosed: alarmKitClosed),
          const SizedBox(height: 8),
          if (!todayPillNumberClosed.value) TodayPillNumberAnnouncementBar(isClosed: todayPillNumberClosed),
          const SizedBox(height: 8),
          if (!restDurationClosed.value) RestDurationAnnouncementBar(isClosed: restDurationClosed),
        ],
      ),
    );
  }
}

/// FirebaseAnalyticsObserver が自動で screen_view を送信するため、
/// RouteSettings.name は必ず設定する。
extension FeatureAppealAnnouncementBarListPageRoute on FeatureAppealAnnouncementBarListPage {
  static Route<dynamic> route() => MaterialPageRoute(
        settings: const RouteSettings(name: 'FeatureAppealAnnouncementBarListPage'),
        builder: (_) => const FeatureAppealAnnouncementBarListPage(),
      );
}
