import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/material.dart';

class WeekdayBadge extends StatelessWidget {
  final Weekday weekday;
  const WeekdayBadge({
    Key? key,
    required this.weekday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Container(
            width: 20,
            height: 30,
            decoration: BoxDecoration(color: PilllColors.white)),
        Container(
          child: Text(weekday.weekdayString(),
              textAlign: TextAlign.end,
              style: FontType.sSmallTitle
                  .merge(TextStyle(color: weekday.weekdayColor()))),
        ),
      ],
    );
  }
}
