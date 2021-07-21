import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:flutter/material.dart';

class LockedMenstruationHistoryRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("🔒", style: TextStyle(fontSize: 16)),
            SizedBox(width: 8),
            PremiumBadge()
          ],
        ),
        SizedBox(height: 6),
        Container(
          width: 280,
          decoration: BoxDecoration(
            color: PilllColors.tinBackground,
            borderRadius: BorderRadius.circular(26),
          ),
          height: 20,
        ),
      ],
    );
  }
}
