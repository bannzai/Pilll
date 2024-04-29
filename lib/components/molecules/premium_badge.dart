import 'package:flutter/material.dart';

import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PremiumBadge extends StatelessWidget {
  const PremiumBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 1, 8, 1),
      decoration: BoxDecoration(
        color: PilllColors.gold,
        borderRadius: BorderRadius.circular(41),
      ),
      child: const Text("Premium",
          style: TextStyle(
            color: TextColor.white,
            fontFamily: FontFamily.number,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          )),
    );
  }
}
