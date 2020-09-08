import 'package:Pilll/main/record/weekday_badge.dart';
import 'package:Pilll/model/weekday.dart';
import 'package:flutter/material.dart';

abstract class CalendarConstants {
  static final int weekdayCount = 7;
}

class Calendar extends StatelessWidget {
  final DateTime firstDayOfMonth;

  const Calendar({Key key, this.firstDayOfMonth}) : super(key: key);

  int _lastDay() {
    return DateTime(firstDayOfMonth.year, firstDayOfMonth.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
              CalendarConstants.weekdayCount,
              (index) => Expanded(
                    child: WeekdayBadge(
                      weekday: Weekday.values[index],
                    ),
                  )),
        ),
        Divider(height: 1),
        ...List.generate((_lastDay() / 7).floor(), (line) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children:
                    List.generate(CalendarConstants.weekdayCount, (weekday) {
                  return Expanded(
                    child: _element(Weekday.values[weekday],
                        line * CalendarConstants.weekdayCount + weekday + 1),
                  );
                }),
              ),
              Divider(height: 1),
            ],
          );
        }),
      ],
    );
  }

  Widget _element(Weekday weekday, int day) {
    return Container(
      height: 60,
      child: Column(
        children: <Widget>[
          Spacer(),
          Text(
            "$day",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: WeekdayFunctions.weekdayColor(weekday),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
