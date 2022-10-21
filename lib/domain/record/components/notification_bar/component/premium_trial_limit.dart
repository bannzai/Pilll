import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumTrialLimitNotificationBar extends StatelessWidget {
  const PremiumTrialLimitNotificationBar({
    Key? key,
    required this.premiumTrialLimit,
  }) : super(key: key);

  final String premiumTrialLimit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      color: PilllColors.secondary,
      child: GestureDetector(
        onTap: () async {
          analytics.logEvent(name: "pressed_trial_limited_notification_bar");
          await launchUrl(Uri.parse("https://pilll.wraptas.site/3abd690f501549c48f813fd310b5f242"));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 24),
            const Spacer(),
            Text(
              premiumTrialLimit,
              style: FontType.assistingBold.merge(TextColorStyle.white),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SvgPicture.asset(
              "images/arrow_right.svg",
              color: Colors.white,
              width: 16,
              height: 16,
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
