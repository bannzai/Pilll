import 'package:flutter/foundation.dart';
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
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/shared_preference/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// FeatureAppeal の index ローテーション計算の起点となる epoch 日付。
/// 変更すると既存ユーザーの「今日表示される Bar」がずれる。
final DateTime _featureAppealEpoch = DateTime(2024, 1, 1);

/// 転換実績に基づく Bar の表示重み。重み w の Bar は 1 周期 (全重みの合計日数) の中で w 日表示される。
///
/// 根拠: PilllBackend issue #373 の FeatureAppeal 課金分析 (2026-09-01 実行) のトライアル 30 日転換率
/// (https://github.com/bannzai/PilllBackend/issues/373#issuecomment-5491959910)。
/// - 3: alarm_kit 25.0% / health_care_integration 18.2% / quick_record 14.3% (転換率上位)
/// - 2: future_schedule 8.3% / menstruation 6.7% / appearance_mode_date 4.8% (転換あり)
/// - 1: 転換 0 の 7 機能 (露出最多の rest_duration を含む)。表示廃止ではなく頻度を下げて測定を続ける
/// 転換者は十数人の小標本で因果効果ではないため、差は 3 倍までに留める (issue #417)。
abstract class FeatureAppealBarWeight {
  static const highConversion = 3;
  static const someConversion = 2;
  static const noConversion = 1;
}

/// 重み付きローテーションの表示順。
/// 「全候補を一巡 → まだ重みが残る候補だけで一巡 → ...」を最大重みの回数繰り返す。
/// 候補ごとに連続させる並び (A,A,A,B,C) では同じ Bar が連日続くため、周回ごとに候補を散らす。
/// 例: 重み [A:3, B:1, C:2] → [A, B, C, A, C, A]
List<T> weightedRotationOrder<T>({required List<({T candidate, int weight})> weightedCandidates}) {
  // ループ条件で毎回 fold しないよう周回数を先に確定する
  final roundCount = weightedCandidates.fold(0, (max, weighted) => weighted.weight > max ? weighted.weight : max);
  return [
    for (var round = 0; round < roundCount; round++)
      for (final weighted in weightedCandidates)
        if (weighted.weight > round) weighted.candidate,
  ];
}

/// AnnouncementBar 領域に表示する FeatureAppeal 専用コンテナ。
/// 候補 Bar を FeatureAppealBarWeight で重み付けした表示順 (weightedRotationOrder) のうち
/// `daysBetween(epoch, today) % 表示順の長さ` の 1 件だけを出す。
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

    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    // featureKey / featureType は各 HelpPage が送る feature_appeal_try_tapped と同じ値 (BigQuery で結合するため)。
    final weightedCandidates = <({({String featureKey, String featureType, Widget bar}) candidate, int weight})>[
      // CriticalAlert と AlarmKit の設定行は settings/page.dart で iOS 配下にあるため、
      // Bar も iOS に限定する (Android ユーザーが HelpPage から設定タブに飛んでも該当行がないため)。
      // dart:io の Platform.isIOS ではなく defaultTargetPlatform を使うのは、
      // Widget テストで debugDefaultTargetPlatformOverride による iOS 扱いを効かせるため。
      if (!quickRecordIsClosed.value)
        (
          candidate: (featureKey: 'quick_record', featureType: 'premium', bar: QuickRecordAnnouncementBar(isClosed: quickRecordIsClosed)),
          weight: FeatureAppealBarWeight.highConversion,
        ),
      if (!reminderNotificationCustomizeWordIsClosed.value)
        (
          candidate: (
            featureKey: 'reminder_notification_customize_word',
            featureType: 'premium',
            bar: ReminderNotificationCustomizeWordAnnouncementBar(isClosed: reminderNotificationCustomizeWordIsClosed),
          ),
          weight: FeatureAppealBarWeight.noConversion,
        ),
      if (!restDurationIsClosed.value)
        (
          candidate: (featureKey: 'rest_duration', featureType: 'free', bar: RestDurationAnnouncementBar(isClosed: restDurationIsClosed)),
          weight: FeatureAppealBarWeight.noConversion,
        ),
      if (isIOS && !criticalAlertIsClosed.value)
        (
          candidate: (featureKey: 'critical_alert', featureType: 'premium', bar: CriticalAlertAnnouncementBar(isClosed: criticalAlertIsClosed)),
          weight: FeatureAppealBarWeight.noConversion,
        ),
      if (appIsReleased && !appearanceModeDateIsClosed.value)
        (
          candidate: (
            featureKey: 'appearance_mode_date',
            featureType: 'premium',
            bar: AppearanceModeDateAnnouncementBar(isClosed: appearanceModeDateIsClosed),
          ),
          weight: FeatureAppealBarWeight.someConversion,
        ),
      if (!recordPillIsClosed.value)
        (
          candidate: (featureKey: 'record_pill', featureType: 'free', bar: RecordPillAnnouncementBar(isClosed: recordPillIsClosed)),
          weight: FeatureAppealBarWeight.noConversion,
        ),
      if (!menstruationIsClosed.value)
        (
          candidate: (featureKey: 'menstruation', featureType: 'free', bar: MenstruationAnnouncementBar(isClosed: menstruationIsClosed)),
          weight: FeatureAppealBarWeight.someConversion,
        ),
      if (!calendarDiaryIsClosed.value)
        (
          candidate: (featureKey: 'calendar_diary', featureType: 'free', bar: CalendarDiaryAnnouncementBar(isClosed: calendarDiaryIsClosed)),
          weight: FeatureAppealBarWeight.noConversion,
        ),
      if (!futureScheduleIsClosed.value)
        (
          candidate: (featureKey: 'future_schedule', featureType: 'free', bar: FutureScheduleAnnouncementBar(isClosed: futureScheduleIsClosed)),
          weight: FeatureAppealBarWeight.someConversion,
        ),
      if (!healthCareIntegrationIsClosed.value)
        (
          candidate: (
            featureKey: 'health_care_integration',
            featureType: 'free',
            bar: HealthCareIntegrationAnnouncementBar(isClosed: healthCareIntegrationIsClosed),
          ),
          weight: FeatureAppealBarWeight.highConversion,
        ),
      if (!creatingNewPillSheetIsClosed.value)
        (
          candidate: (
            featureKey: 'creating_new_pillsheet',
            featureType: 'premium',
            bar: CreatingNewPillSheetAnnouncementBar(isClosed: creatingNewPillSheetIsClosed),
          ),
          weight: FeatureAppealBarWeight.noConversion,
        ),
      if (isIOS && !alarmKitIsClosed.value)
        (
          candidate: (featureKey: 'alarm_kit', featureType: 'premium', bar: AlarmKitAnnouncementBar(isClosed: alarmKitIsClosed)),
          weight: FeatureAppealBarWeight.highConversion,
        ),
      if (!todayPillNumberIsClosed.value)
        (
          candidate: (featureKey: 'today_pill_number', featureType: 'free', bar: TodayPillNumberAnnouncementBar(isClosed: todayPillNumberIsClosed)),
          weight: FeatureAppealBarWeight.noConversion,
        ),
    ];
    final rotationOrder = weightedRotationOrder(weightedCandidates: weightedCandidates);
    final shown = rotationOrder.isEmpty ? null : rotationOrder[daysBetween(_featureAppealEpoch, today()) % rotationOrder.length];

    // 重み付け後の表示分布を BigQuery (feature_appeal_bar_shown) で検証するための impression。
    // 親 (AnnouncementBar) の再ビルドで重複計上しないよう、表示する Bar が変わった時だけ送る。
    useEffect(() {
      if (shown != null) {
        analytics.logEvent(
          name: 'feature_appeal_bar_shown',
          parameters: {
            'feature_key': shown.featureKey,
            'feature_type': shown.featureType,
            'weight': weightedCandidates.firstWhere((weighted) => weighted.candidate.featureKey == shown.featureKey).weight,
            'rotation_length': rotationOrder.length,
          },
        );
      }
      return null;
    }, [shown?.featureKey]);

    if (shown == null) {
      return const SizedBox.shrink();
    }
    return Semantics(
      identifier: 'feature_appeal_bar',
      child: shown.bar,
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
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    return [
      // CriticalAlert / AlarmKit は iOS 限定機能のため、Android では候補から除外する。
      isIOS && !(sharedPreferences.getBool(BoolKey.criticalAlertFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.reminderNotificationCustomizeWordFeatureAppealIsClosed) ?? false),
      appIsReleased && !(sharedPreferences.getBool(BoolKey.appearanceModeDateFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.recordPillFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.menstruationFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.calendarDiaryFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.futureScheduleFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.healthCareIntegrationFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.quickRecordFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.creatingNewPillSheetFeatureAppealIsClosed) ?? false),
      isIOS && !(sharedPreferences.getBool(BoolKey.alarmKitFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.todayPillNumberFeatureAppealIsClosed) ?? false),
      !(sharedPreferences.getBool(BoolKey.restDurationFeatureAppealIsClosed) ?? false),
    ].any((available) => available);
  }
}
