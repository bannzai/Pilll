import 'package:pilll/components/organisms/calendar/monthly/calendar_state.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/material.dart';

abstract class CalendarConstants {
  static final double tileHeight = 66;
  static const int constantLineCount = 6;
}

class MonthlyCalendarLayout extends StatelessWidget {
  final MonthlyCalendarState state;
  final Widget Function(BuildContext, DateRange) weeklyCalendarBuilder;

  const MonthlyCalendarLayout({
    Key? key,
    required this.state,
    required this.weeklyCalendarBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
              Weekday.values.length,
              (index) => Expanded(
                    child: WeekdayBadge(
                      weekday: Weekday.values[index],
                    ),
                  )),
        ),
        Divider(height: 1),
        ...List.generate(CalendarConstants.constantLineCount, (offset) {
          final line = offset + 1;
          if (state.weeklineCount() < CalendarConstants.constantLineCount &&
              line == CalendarConstants.constantLineCount) {
            return Container(height: CalendarConstants.tileHeight);
          }
          final weeklyCalendar = weeklyCalendarBuilder(
            context,
            state.dateRangeOfLine(line),
          );
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [weeklyCalendar, Divider(height: 1)]);
        }),
      ],
    );
  }
}
