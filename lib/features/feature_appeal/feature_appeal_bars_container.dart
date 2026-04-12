import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/feature_appeal/appearance_mode_date/appearance_mode_date_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/calendar_diary/calendar_diary_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/critical_alert/critical_alert_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/future_schedule/future_schedule_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/health_care_integration/health_care_integration_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/menstruation/menstruation_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/record_pill/record_pill_announcement_bar.dart';
import 'package:pilll/features/feature_appeal/reminder_notification_customize_word/reminder_notification_customize_word_announcement_bar.dart';
import 'package:pilll/provider/shared_preferences.dart';
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
  const FeatureAppealBarsContainer({super.key, required this.appIsReleased});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    useEffect(() {
      criticalAlertIsClosed.addListener(() {
        sharedPreferences.setBool(BoolKey.criticalAlertFeatureAppealIsClosed, criticalAlertIsClosed.value);
      });
      reminderNotificationCustomizeWordIsClosed.addListener(() {
        sharedPreferences.setBool(
          BoolKey.reminderNotificationCustomizeWordFeatureAppealIsClosed,
          reminderNotificationCustomizeWordIsClosed.value,
        );
      });
      appearanceModeDateIsClosed.addListener(() {
        sharedPreferences.setBool(BoolKey.appearanceModeDateFeatureAppealIsClosed, appearanceModeDateIsClosed.value);
      });
      recordPillIsClosed.addListener(() {
        sharedPreferences.setBool(BoolKey.recordPillFeatureAppealIsClosed, recordPillIsClosed.value);
      });
      menstruationIsClosed.addListener(() {
        sharedPreferences.setBool(BoolKey.menstruationFeatureAppealIsClosed, menstruationIsClosed.value);
      });
      calendarDiaryIsClosed.addListener(() {
        sharedPreferences.setBool(BoolKey.calendarDiaryFeatureAppealIsClosed, calendarDiaryIsClosed.value);
      });
      futureScheduleIsClosed.addListener(() {
        sharedPreferences.setBool(BoolKey.futureScheduleFeatureAppealIsClosed, futureScheduleIsClosed.value);
      });
      healthCareIntegrationIsClosed.addListener(() {
        sharedPreferences.setBool(BoolKey.healthCareIntegrationFeatureAppealIsClosed, healthCareIntegrationIsClosed.value);
      });
      return null;
    }, []);

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
    ];
    if (candidates.isEmpty) {
      return const SizedBox.shrink();
    }
    return candidates[daysBetween(_featureAppealEpoch, today()) % candidates.length];
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
    ].any((available) => available);
  }
}
