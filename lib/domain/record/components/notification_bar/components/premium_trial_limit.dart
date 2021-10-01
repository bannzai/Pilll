import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/links.dart';
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
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: GestureDetector(
        onTap: () async {
          analytics.logEvent(name: "pressed_trial_limited_notification_bar");
          await launch(preimumLink);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 24),
            Spacer(),
            Text(
              premiumTrialLimit,
              style: FontType.assistingBold.merge(TextColorStyle.white),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            SvgPicture.asset(
              "images/arrow_right.svg",
              color: Colors.white,
              width: 16,
              height: 16,
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
