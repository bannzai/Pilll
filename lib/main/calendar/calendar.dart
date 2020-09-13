import 'package:Pilll/main/calendar/calculator.dart';
import 'package:Pilll/main/record/weekday_badge.dart';
import 'package:Pilll/model/weekday.dart';
import 'package:Pilll/theme/font.dart';
import 'package:flutter/material.dart';

abstract class CalendarConstants {
  static final int weekdayCount = 7;
  static final double tileHeight = 60;
}

class Calendar extends StatelessWidget {
  final Calculator calculator;

  const Calendar({Key key, this.calculator}) : super(key: key);

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
        ...List.generate(calculator.lineCount(), (line) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: Weekday.values.map((weekday) {
                  bool isPreviousMonth =
                      weekday.index < calculator.weekdayOffset() && line == 0;
                  if (isPreviousMonth) {
                    return CalendarDayTile(
                        disable: true,
                        weekday: weekday,
                        day: calculator
                            .dateTimeForPreviousMonthTile(weekday)
                            .day);
                  }
                  int day = line * CalendarConstants.weekdayCount +
                      weekday.index -
                      calculator.weekdayOffset() +
                      1;
                  bool isNextMonth = day > calculator.lastDay();
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
}

class CalendarDayTile extends StatelessWidget {
  final int day;
  final Weekday weekday;
  final bool disable;

  final Widget upperWidget;
  final Widget lowerWidget;

  const CalendarDayTile(
      {Key key,
      this.day,
      this.weekday,
      this.upperWidget,
      this.lowerWidget,
      this.disable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: CalendarConstants.tileHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            upperWidget ?? Spacer(),
            Spacer(),
            Text(
              "$day",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: disable
                    ? WeekdayFunctions.weekdayColor(weekday)
                        .withAlpha((255 * 0.4).floor())
                    : WeekdayFunctions.weekdayColor(weekday),
              ).merge(FontType.calendarDay),
            ),
            Spacer(),
            lowerWidget ?? Spacer(),
          ],
        ),
      ),
    );
  }
}
