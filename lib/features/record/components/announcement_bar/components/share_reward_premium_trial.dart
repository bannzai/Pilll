import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ShareRewardPremiumTrialAnnoumcenetBar extends StatelessWidget {
  const ShareRewardPremiumTrialAnnoumcenetBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      color: PilllColors.primary,
      child: GestureDetector(
        onTap: () async {
          analytics.logEvent(name: "pressed_share_reward_announcement_bar");

          await Share.share('''Pilll ピル服用に特化したピルリマインダーアプリ

iOS: https://onl.sc/piiY1A6
Android: https://onl.sc/c9xnQUk''');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 24),
            const Spacer(),
            const Text(
              "SNSシェアしてプレミアム機能を30日間無料で再体験できます！",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: TextColor.white,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SvgPicture.asset(
              "images/arrow_right.svg",
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  static String? retrievePremiumTrialLimit(User user) {
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

    if (trialDeadlineDate.isBefore(now())) {
      return null;
    }

    final diff = daysBetween(now(), trialDeadlineDate);
    return "残り$diff日間すべての機能を使えます";
  }
}
