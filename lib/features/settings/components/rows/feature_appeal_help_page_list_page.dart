import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/features/feature_appeal/alarm_kit/alarm_kit_help_page.dart';
import 'package:pilll/features/feature_appeal/appearance_mode_date/appearance_mode_date_help_page.dart';
import 'package:pilll/features/feature_appeal/calendar_diary/calendar_diary_help_page.dart';
import 'package:pilll/features/feature_appeal/creating_new_pillsheet/creating_new_pillsheet_help_page.dart';
import 'package:pilll/features/feature_appeal/critical_alert/critical_alert_help_page.dart';
import 'package:pilll/features/feature_appeal/future_schedule/future_schedule_help_page.dart';
import 'package:pilll/features/feature_appeal/health_care_integration/health_care_integration_help_page.dart';
import 'package:pilll/features/feature_appeal/menstruation/menstruation_help_page.dart';
import 'package:pilll/features/feature_appeal/quick_record/quick_record_help_page.dart';
import 'package:pilll/features/feature_appeal/record_pill/record_pill_help_page.dart';
import 'package:pilll/features/feature_appeal/reminder_notification_customize_word/reminder_notification_customize_word_help_page.dart';
import 'package:pilll/features/feature_appeal/rest_duration/rest_duration_help_page.dart';
import 'package:pilll/features/feature_appeal/today_pill_number/today_pill_number_help_page.dart';

/// FeatureAppeal の全 HelpPage への遷移リンクを一覧表示するページ。
/// 開発者オプションからアクセスし、各ページの内容を確認・評価する用途。
class FeatureAppealHelpPageListPage extends StatelessWidget {
  const FeatureAppealHelpPageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <({String label, String type, Route<dynamic> Function() routeFactory})>[
      (label: 'Critical Alert', type: 'premium', routeFactory: CriticalAlertHelpPageRoute.route),
      (label: '通知メッセージカスタマイズ', type: 'premium', routeFactory: ReminderNotificationCustomizeWordHelpPageRoute.route),
      (label: 'ピルシート外観モード(date)', type: 'premium', routeFactory: AppearanceModeDateHelpPageRoute.route),
      (label: 'ピル記録', type: 'free', routeFactory: RecordPillHelpPageRoute.route),
      (label: '生理記録', type: 'free', routeFactory: MenstruationHelpPageRoute.route),
      (label: 'カレンダー・日記', type: 'free', routeFactory: CalendarDiaryHelpPageRoute.route),
      (label: '未来の予定', type: 'free', routeFactory: FutureScheduleHelpPageRoute.route),
      (label: 'ヘルスケア連携', type: 'free', routeFactory: HealthCareIntegrationHelpPageRoute.route),
      (label: 'クイックレコード', type: 'premium', routeFactory: QuickRecordHelpPageRoute.route),
      (label: 'ピルシート自動追加', type: 'premium', routeFactory: CreatingNewPillSheetHelpPageRoute.route),
      (label: 'AlarmKit (iOS 26+)', type: 'premium', routeFactory: AlarmKitHelpPageRoute.route),
      (label: '今日の服用番号変更', type: 'free', routeFactory: TodayPillNumberHelpPageRoute.route),
      (label: '服用おやすみ', type: 'free', routeFactory: RestDurationHelpPageRoute.route),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('FeatureAppeal HelpPage 一覧'),
        backgroundColor: AppColors.background,
      ),
      body: ListView.separated(
        itemCount: pages.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final page = pages[index];
          return ListTile(
            title: Text(page.label),
            subtitle: Text(page.type),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(page.routeFactory()),
          );
        },
      ),
    );
  }
}

/// FirebaseAnalyticsObserver が自動で screen_view を送信するため、
/// RouteSettings.name は必ず設定する。
extension FeatureAppealHelpPageListPageRoute on FeatureAppealHelpPageListPage {
  static Route<dynamic> route() => MaterialPageRoute(
        settings: const RouteSettings(name: 'FeatureAppealHelpPageListPage'),
        builder: (_) => const FeatureAppealHelpPageListPage(),
      );
}
