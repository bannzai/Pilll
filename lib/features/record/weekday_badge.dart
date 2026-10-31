import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/material.dart';

abstract class WeekdayBadgeConst {
  static const double height = 30;
}

class WeekdayBadge extends StatelessWidget {
  final Weekday weekday;
  const WeekdayBadge({super.key, required this.weekday});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: WeekdayBadgeConst.height,
      color: AppColors.white,
      // pt「dom.」・fr「sam.」のように曜日の略記が幅 20 に収まらない言語では「.」だけが 2 行目に落ちて枠からはみ出すため、1 行のまま縮小する
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            weekday.weekdayString(),
            maxLines: 1,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w600,
              fontSize: 9,
            ).merge(TextStyle(color: weekday.weekdayColor())),
          ),
        ),
      ),
    );
  }
}
