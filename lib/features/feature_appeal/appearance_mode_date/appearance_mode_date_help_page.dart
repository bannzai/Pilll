import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/features/record/components/setting/components/appearance_mode/select_appearance_mode_modal.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';

/// ピルシート外観モード(date) (有料機能) の説明と「実際に試す」導線を持つヘルプページ。
class AppearanceModeDateHelpPage extends ConsumerWidget {
  const AppearanceModeDateHelpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).requireValue;
    final pillSheetGroup = ref.watch(latestPillSheetGroupProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(L.appearanceModeDateFeatureAppealTitle),
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
                'images/switching_appearance_mode.svg',
                width: 120,
                height: 80,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                L.appearanceModeDateFeatureAppealHeadline,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: FontFamily.japanese,
                  color: TextColor.main,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _featureCard(icon: Icons.calendar_today, text: L.appearanceModeDateFeatureAppealPoint1),
            const SizedBox(height: 8),
            _featureCard(icon: Icons.visibility, text: L.appearanceModeDateFeatureAppealPoint2),
            const SizedBox(height: 8),
            _featureCard(icon: Icons.settings, text: L.appearanceModeDateFeatureAppealPoint3),
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
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: TextColor.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: Text(
                  L.pillSheetSettings,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: TextColor.main,
                  ),
                ),
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
                  'feature_key': 'appearance_mode_date',
                  'feature_type': 'premium',
                  'is_paywall_shown': !user.premiumOrTrial ? 1 : 0,
                },
              );
              if (!user.premiumOrTrial) {
                analytics.logEvent(
                  name: 'feature_appeal_paywall_shown',
                  parameters: {'feature_key': 'appearance_mode_date'},
                );
                await showPremiumIntroductionSheet(context);
                return;
              }
              if (pillSheetGroup == null) {
                return;
              }
              showSelectAppearanceModeModal(
                context,
                user: user,
                pillSheetGroup: pillSheetGroup,
              );
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
extension AppearanceModeDateHelpPageRoute on AppearanceModeDateHelpPage {
  static Route<dynamic> route() => MaterialPageRoute(
        settings: const RouteSettings(name: 'AppearanceModeDateHelpPage'),
        builder: (_) => const AppearanceModeDateHelpPage(),
      );
}
