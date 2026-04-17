import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/features/home/page.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';

/// ピルシートグループ自動追加 (Premium機能) の説明と「実際に試す」導線を持つヘルプページ。
/// 「実際に試す」では設定タブへ案内する (設定画面のピルシートグループ自動追加トグルから操作する)。
/// 非 Premium / 非トライアルユーザーには PremiumIntroductionSheet を開く。
class CreatingNewPillSheetHelpPage extends ConsumerWidget {
  const CreatingNewPillSheetHelpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(L.creatingNewPillSheetFeatureAppealTitle),
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
                'images/empty_pill_sheet_type.svg',
                width: 80,
                height: 80,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                L.creatingNewPillSheetFeatureAppealHeadline,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: FontFamily.japanese,
                  color: TextColor.main,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _featureCard(icon: Icons.auto_awesome, text: L.creatingNewPillSheetFeatureAppealPoint1),
            const SizedBox(height: 8),
            _featureCard(icon: Icons.autorenew, text: L.creatingNewPillSheetFeatureAppealPoint2),
            const SizedBox(height: 8),
            _featureCard(icon: Icons.toggle_on, text: L.creatingNewPillSheetFeatureAppealPoint3),
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
            _mockTabBar(selectedIndex: 3),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Center(child: Icon(Icons.arrow_downward, size: 28, color: AppColors.primary)),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: IgnorePointer(
                child: SwitchListTile(
                  value: false,
                  onChanged: (_) {},
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(
                          L.autoAddPillSheetGroup,
                          style: const TextStyle(
                            fontFamily: FontFamily.japanese,
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const PremiumBadge(),
                    ],
                  ),
                  subtitle: Text(
                    L.autoAddNewSheetAfterCurrentEnds,
                    style: const TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ),
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
              final user = ref.read(userProvider).requireValue;
              analytics.logEvent(
                name: 'feature_appeal_try_tapped',
                parameters: {
                  'feature_key': 'creating_new_pillsheet',
                  'feature_type': 'premium',
                  'is_paywall_shown': !user.premiumOrTrial ? 1 : 0,
                },
              );
              if (!user.premiumOrTrial) {
                analytics.logEvent(
                  name: 'feature_appeal_paywall_shown',
                  parameters: {'feature_key': 'creating_new_pillsheet'},
                );
                await showPremiumIntroductionSheet(context);
                return;
              }
              final tabController = ref.read(homeTabControllerProvider);
              Navigator.of(context).popUntil((r) => r.isFirst);
              tabController?.animateTo(HomePageTabType.setting.index);
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
extension CreatingNewPillSheetHelpPageRoute on CreatingNewPillSheetHelpPage {
  static Route<dynamic> route() => MaterialPageRoute(
        settings: const RouteSettings(name: 'CreatingNewPillSheetHelpPage'),
        builder: (_) => const CreatingNewPillSheetHelpPage(),
      );
}
