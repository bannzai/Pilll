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
    final user = ref.watch(userProvider).valueOrNull;
    final pillSheetGroup = ref.watch(latestPillSheetGroupProvider).valueOrNull;
    if (user == null) {
      return const Scaffold(backgroundColor: AppColors.background);
    }

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
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
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
            Text(
              L.appearanceModeDateFeatureAppealHeadline,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              L.appearanceModeDateFeatureAppealBody,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: PrimaryButton(
              text: L.featureAppealTryFeature,
              onPressed: () async {
                final isPaywallShown = !user.premiumOrTrial;
                analytics.logEvent(
                  name: 'feature_appeal_try_tapped',
                  parameters: {
                    'feature_key': 'appearance_mode_date',
                    'feature_type': 'premium',
                    'is_paywall_shown': isPaywallShown ? 1 : 0,
                  },
                );
                if (isPaywallShown) {
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
