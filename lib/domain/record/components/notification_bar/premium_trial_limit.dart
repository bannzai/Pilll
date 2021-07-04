import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PremiumTrialLimitNotificationBar extends StatelessWidget {
  const PremiumTrialLimitNotificationBar({
    Key? key,
    required this.premiumTrialLimit,
  }) : super(key: key);

  final String premiumTrialLimit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(premiumTrialLimit,
          style: FontType.assistingBold.merge(TextColorStyle.white)),
    );
  }
}
