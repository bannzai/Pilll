import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumTrialLimitAnnouncementBar extends StatelessWidget {
  const PremiumTrialLimitAnnouncementBar({super.key, required this.premiumTrialLimit});

  final String premiumTrialLimit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        analytics.logEvent(name: 'pressed_trial_limited_announcement_bar');
        await launchUrl(Uri.parse('https://pilll.notion.site/3abd690f501549c48f813fd310b5f242'));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        color: AppColors.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 24),
            const Spacer(),
            Text(
              premiumTrialLimit,
              style: const TextStyle(fontFamily: FontFamily.japanese, fontWeight: FontWeight.w600, fontSize: 14, color: TextColor.white),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SvgPicture.asset('images/arrow_right.svg', colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), width: 16, height: 16),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  static String? premiumTrialLimitMessage(User user) {
    if (user.isPremium) {
      return null;
    }
    if (!user.isTrial) {
      return null;
    }
    final trialDeadlineDate = user.trialDeadlineDate;
    if (trialDeadlineDate == null) {
      return null;
    }

    final diff = daysBetween(now(), trialDeadlineDate);
    final base = L.remainingDaysAllFeatures(diff);
    return '$base\n${L.specialDiscountPriceNow}';
  }
}
