import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/material.dart';

abstract class WeekdayBadgeConst {
  static const double height = 30;
}

class WeekdayBadge extends StatelessWidget {
  final Weekday weekday;
  const WeekdayBadge({
    super.key,
    required this.weekday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: WeekdayBadgeConst.height,
      color: PilllColors.white,
      child: Center(
        child: Text(weekday.weekdayString(),
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ).merge(TextStyle(color: weekday.weekdayColor()))),
      ),
    );
  }
}
