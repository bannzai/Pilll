import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/pill_sheet_modified_history/page.dart';
import 'package:pilll/utils/analytics.dart';

/// ピル記録/服用履歴 (無料機能) の説明と「実際に試す」導線を持つヘルプページ。
class RecordPillHelpPage extends StatelessWidget {
  const RecordPillHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(L.recordPillFeatureAppealTitle),
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SvgPicture.asset(
                'images/tab_icon_pill_enable.svg',
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              L.recordPillFeatureAppealHeadline,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
            const SizedBox(height: 20),
            _featureCard(icon: Icons.touch_app, text: L.recordPillFeatureAppealPoint1),
            const SizedBox(height: 8),
            _featureCard(icon: Icons.undo, text: L.recordPillFeatureAppealPoint2),
            const SizedBox(height: 8),
            _featureCard(icon: Icons.history, text: L.recordPillFeatureAppealPoint3),
            const SizedBox(height: 28),
            Text(
              L.featureAppealLocationLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: FontFamily.japanese,
                color: TextColor.darkGray,
              ),
            ),
            const SizedBox(height: 8),
            _mockTabBar(selectedIndex: 0),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Center(child: Icon(Icons.arrow_downward, size: 28, color: AppColors.primary)),
            ),
            Container(
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 7; i++) ...[
                    if (i > 0) const SizedBox(width: 6),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _mockPillMark(isDone: i < 3, isSelected: i == 3),
                        if (i == 3)
                          const Positioned(
                            bottom: 0,
                            right: -6,
                            child: Icon(Icons.touch_app, size: 22, color: AppColors.primary),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Center(child: Icon(Icons.arrow_downward, size: 28, color: AppColors.primary)),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                children: [
                  _mockHistoryRow(day: DateTime.now().subtract(const Duration(days: 2)), pillNumber: 1, time: '19:00'),
                  const Divider(height: 16),
                  _mockHistoryRow(day: DateTime.now().subtract(const Duration(days: 1)), pillNumber: 2, time: '19:30'),
                  const Divider(height: 16),
                  _mockHistoryRow(day: DateTime.now(), pillNumber: 3, time: '20:00'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: PrimaryButton(
            text: L.featureAppealTryFeature,
            onPressed: () async {
              analytics.logEvent(
                name: 'feature_appeal_try_tapped',
                parameters: {
                  'feature_key': 'record_pill',
                  'feature_type': 'free',
                  'is_paywall_shown': 0,
                },
              );
              Navigator.of(context).push(PillSheetModifiedHistoriesPageRoute.route());
            },
          ),
        ),
      ),
    );
  }

  Widget _mockTabBar({required int selectedIndex}) {
    final tabs = [
      (icon: 'images/tab_icon_pill_enable.svg', disabledIcon: 'images/tab_icon_pill_disable.svg', label: L.pill),
      (icon: 'images/menstruation.svg', disabledIcon: 'images/menstruation_disable.svg', label: L.menstruation),
      (icon: 'images/tab_icon_calendar_enable.svg', disabledIcon: 'images/tab_icon_calendar_disable.svg', label: L.calendar),
      (icon: 'images/tab_icon_setting_enable.svg', disabledIcon: 'images/tab_icon_setting_disable.svg', label: L.settings),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < tabs.length; i++)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: i == selectedIndex
                      ? BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2))
                      : null,
                  child: SvgPicture.asset(
                    i == selectedIndex ? tabs[i].icon : tabs[i].disabledIcon,
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  tabs[i].label,
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: FontFamily.japanese,
                    color: i == selectedIndex ? AppColors.primary : TextColor.darkGray,
                    fontWeight: i == selectedIndex ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _mockHistoryRow({required DateTime day, required int pillNumber, required String time}) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            '${day.month}/${day.day}',
            style: const TextStyle(fontSize: 12, fontFamily: FontFamily.number, color: TextColor.main),
          ),
        ),
        const SizedBox(width: 8),
        Container(height: 20, width: 0.5, color: AppColors.border),
        const SizedBox(width: 8),
        SizedBox(
          width: 50,
          child: Text(
            '$pillNumber番',
            style: const TextStyle(fontSize: 12, fontFamily: FontFamily.japanese, fontWeight: FontWeight.w500, color: TextColor.main),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          time,
          style: const TextStyle(fontSize: 12, fontFamily: FontFamily.number, color: TextColor.darkGray),
        ),
        const Spacer(),
        for (var i = 0; i < pillNumber; i++) ...[
          if (i > 0) const SizedBox(width: 2),
          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
        ],
      ],
    );
  }

  Widget _mockPillMark({required bool isDone, required bool isSelected}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isDone ? AppColors.lightGray : (isSelected ? AppColors.enable : AppColors.potti),
        shape: BoxShape.circle,
      ),
      child: isDone ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
    );
  }

  Widget _featureCard({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w500,
                color: TextColor.main,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// FirebaseAnalyticsObserver が自動で screen_view を送信するため、
/// RouteSettings.name は必ず設定する (lib/app.dart で MaterialApp に登録済み)。
extension RecordPillHelpPageRoute on RecordPillHelpPage {
  static Route<dynamic> route() => MaterialPageRoute(
        settings: const RouteSettings(name: 'RecordPillHelpPage'),
        builder: (_) => const RecordPillHelpPage(),
      );
}
