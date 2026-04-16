import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/home/page.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';

/// ヘルスケア連携 (無料機能) の説明と「実際に試す」導線を持つヘルプページ。
/// 「実際に試す」では設定タブへ案内する (HealthKit 認可フローは設定画面の HealthCareRow から発火させる)。
class HealthCareIntegrationHelpPage extends ConsumerWidget {
  const HealthCareIntegrationHelpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(L.healthCareIntegrationFeatureAppealTitle),
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
                'images/heart.svg',
                width: 80,
                height: 80,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              L.healthCareIntegrationFeatureAppealHeadline,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
            const SizedBox(height: 20),
            _featureCard(icon: Icons.sync, text: L.healthCareIntegrationFeatureAppealPoint1),
            const SizedBox(height: 8),
            _featureCard(icon: Icons.favorite, text: L.healthCareIntegrationFeatureAppealPoint2),
            const SizedBox(height: 8),
            _featureCard(icon: Icons.phone_iphone, text: L.healthCareIntegrationFeatureAppealPoint3),
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
            const SizedBox(height: 4),
            Text(
              '${L.settings} > ${L.menstruation}',
              style: const TextStyle(
                fontSize: 12,
                fontFamily: FontFamily.japanese,
                color: TextColor.darkGray,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: IgnorePointer(
                child: ListTile(
                  title: Text(
                    L.healthCareIntegration,
                    style: const TextStyle(
                      fontFamily: FontFamily.roboto,
                      fontWeight: FontWeight.w300,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    L.healthCareIntegrationDescription,
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
              analytics.logEvent(
                name: 'feature_appeal_try_tapped',
                parameters: {
                  'feature_key': 'health_care_integration',
                  'feature_type': 'free',
                  'is_paywall_shown': 0,
                },
              );
              final tabController = ref.read(homeTabControllerProvider);
              Navigator.of(context).popUntil((r) => r.isFirst);
              tabController?.animateTo(HomePageTabType.setting.index);
            },
          ),
        ),
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
extension HealthCareIntegrationHelpPageRoute on HealthCareIntegrationHelpPage {
  static Route<dynamic> route() => MaterialPageRoute(
        settings: const RouteSettings(name: 'HealthCareIntegrationHelpPage'),
        builder: (_) => const HealthCareIntegrationHelpPage(),
      );
}
