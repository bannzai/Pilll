import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/features/reminder_notification_customize_word/page.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';

/// 通知メッセージカスタマイズ (有料機能) の説明と「実際に試す」導線を持つヘルプページ。
class ReminderNotificationCustomizeWordHelpPage extends ConsumerWidget {
  const ReminderNotificationCustomizeWordHelpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).valueOrNull;
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(L.reminderNotificationCustomizeWordFeatureAppealTitle),
          backgroundColor: AppColors.background,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(L.reminderNotificationCustomizeWordFeatureAppealTitle),
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
                'images/edit.svg',
                width: 80,
                height: 80,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              L.reminderNotificationCustomizeWordFeatureAppealHeadline,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.japanese,
                color: TextColor.main,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              L.reminderNotificationCustomizeWordFeatureAppealBody,
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
                analytics.logEvent(
                  name: 'feature_appeal_try_tapped',
                  parameters: {
                    'feature_key': 'reminder_notification_customize_word',
                    'feature_type': 'premium',
                    'is_paywall_shown': !user.premiumOrTrial ? 1 : 0,
                  },
                );
                if (!user.premiumOrTrial) {
                  analytics.logEvent(
                    name: 'feature_appeal_paywall_shown',
                    parameters: {'feature_key': 'reminder_notification_customize_word'},
                  );
                  await showPremiumIntroductionSheet(context);
                  return;
                }
                await Navigator.of(context).push(ReminderNotificationCustomizeWordPageRoutes.route());
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
extension ReminderNotificationCustomizeWordHelpPageRoute on ReminderNotificationCustomizeWordHelpPage {
  static Route<dynamic> route() => MaterialPageRoute(
        settings: const RouteSettings(name: 'ReminderNotificationCustomizeWordHelpPage'),
        builder: (_) => const ReminderNotificationCustomizeWordHelpPage(),
      );
}
