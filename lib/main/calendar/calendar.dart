import 'package:Pilll/main/record/weekday_badge.dart';
import 'package:Pilll/model/weekday.dart';
import 'package:Pilll/theme/font.dart';
import 'package:flutter/material.dart';

abstract class CalendarConstants {
  static final int weekdayCount = 7;
  static final double tileHeight = 60;
}

class Calendar extends StatelessWidget {
  final DateTime firstDayOfMonth;
  const Calendar({Key key, this.firstDayOfMonth}) : super(key: key);

  DateTime _dateTimeForFirstDayofMonth() {
    return DateTime(firstDayOfMonth.year, firstDayOfMonth.month, 1);
  }

  int _lastDay() =>
      DateTime(firstDayOfMonth.year, firstDayOfMonth.month + 1, 0).day;
  int _weekdayOffset() =>
      WeekdayFunctions.weekdayFromDate(_dateTimeForFirstDayofMonth()).index;
  int _previousMonthDayCount() => _weekdayOffset();
  int _tileCount() => _previousMonthDayCount() + _lastDay();
  int _lineCount() => (_tileCount() / 7).ceil();

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
        ...List.generate(_lineCount(), (line) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children:
                    List.generate(CalendarConstants.weekdayCount, (weekday) {
                  return Expanded(
                    child: _tile(Weekday.values[weekday],
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

  Widget _tile(Weekday weekday, int day) {
    return Container(
      height: CalendarConstants.tileHeight,
      child: Column(
        children: <Widget>[
          Spacer(),
          Text(
            "$day",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: WeekdayFunctions.weekdayColor(weekday),
            ).merge(FontType.calendarDay),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
