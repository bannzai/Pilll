import 'package:Pilll/main/record/weekday_badge.dart';
import 'package:Pilll/model/weekday.dart';
import 'package:Pilll/theme/font.dart';
import 'package:flutter/material.dart';

abstract class CalendarConstants {
  static final int weekdayCount = 7;
  static final double tileHeight = 60;
}

class Calendar extends StatelessWidget {
  final DateTime date;
  const Calendar({Key key, this.date}) : super(key: key);

  DateTime _dateTimeForFirstDayofMonth() {
    return DateTime(date.year, date.month, 1);
  }

  int _lastDay() => DateTime(date.year, date.month + 1, 0).day;
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
                children: Weekday.values.map((weekday) {
                  bool isPreviousMonth =
                      weekday.index <= _weekdayOffset() && line == 0;
                  if (isPreviousMonth) {
                    return CalendarDayTile(
                        weekday: weekday,
                        day: _dateTimeForPreviousMonthTile(weekday).day);
                  }
                  int day = line * CalendarConstants.weekdayCount +
                      weekday.index -
                      _weekdayOffset() +
                      1;
                  bool isNextMonth = day > _lastDay();
                  if (isNextMonth) {
                    return Expanded(child: Container());
                  }
                  return CalendarDayTile(
                    weekday: weekday,
                    day: day,
                  );
                }).toList(),
              ),
              Divider(height: 1),
            ],
          );
        }),
      ],
    );
  }

  DateTime _dateTimeForPreviousMonthTile(Weekday weekday) {
    var dateTimeForLastDayOfPreviousMonth = DateTime(date.year, date.month, 0);
    var offset =
        WeekdayFunctions.weekdayFromDate(dateTimeForLastDayOfPreviousMonth)
            .index;
    return DateTime(
        dateTimeForLastDayOfPreviousMonth.year,
        dateTimeForLastDayOfPreviousMonth.month,
        dateTimeForLastDayOfPreviousMonth.day - offset + weekday.index);
  }
}

class CalendarDayTile extends StatelessWidget {
  final int day;
  final Weekday weekday;

  final Widget upperWidget;
  final Widget lowerWidget;

  const CalendarDayTile(
      {Key key, this.day, this.weekday, this.upperWidget, this.lowerWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: CalendarConstants.tileHeight,
        child: Column(
          children: <Widget>[
            upperWidget ?? Spacer(),
            Text(
              "$day",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: WeekdayFunctions.weekdayColor(weekday),
              ).merge(FontType.calendarDay),
            ),
            upperWidget ?? Spacer(),
          ],
        ),
      ),
    );
  }
}
