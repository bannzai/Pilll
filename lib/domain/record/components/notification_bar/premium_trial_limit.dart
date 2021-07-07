import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: () async {
        await launch(preimumLink);
      },
      child: Center(
        child: Text(premiumTrialLimit,
            style: FontType.assistingBold.merge(TextColorStyle.white)),
      ),
    );
  }
}
