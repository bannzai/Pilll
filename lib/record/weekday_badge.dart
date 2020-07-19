import 'package:Pilll/color.dart';
import 'package:Pilll/record/model/weekday.dart';
import 'package:flutter/material.dart';

class WeekdayBadge extends StatelessWidget {
  final Weekday weekday;
  const WeekdayBadge({
    Key key,
    this.weekday,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Container(
            width: 20,
            height: 30,
            decoration: BoxDecoration(color: PilllColors.mat)),
        Container(
          child: Text(WeekdayFunctions.weekdayString(weekday),
              textAlign: TextAlign.end,
              style: TextStyle(color: WeekdayFunctions.weekdayColor(weekday))),
        ),
      ],
    );
  }
}
