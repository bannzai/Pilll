import 'package:Pilll/theme/color.dart';
import 'package:Pilll/entity/weekday.dart';
import 'package:flutter/material.dart';

class WeekdayBadge extends StatelessWidget {
  final Weekday weekday;
  const WeekdayBadge({
    Key key,
    @required this.weekday,
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
          child: Text(weekday.weekdayString(),
              textAlign: TextAlign.end,
              style: TextStyle(color: weekday.weekdayColor())),
        ),
      ],
    );
  }
}
