import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/material.dart';

abstract class CalendarConstants {
  static final double tileHeight = 66;
  static const int constantLineCount = 6;
}

class MonthlyCalendarLayout extends StatelessWidget {
  // NOTE: If return null fill container at bottom
  final Widget? Function(BuildContext, int) weeklyCalendarBuilder;

  const MonthlyCalendarLayout({
    Key? key,
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
          final weeklyCalendar = weeklyCalendarBuilder(context, offset);
          if (weeklyCalendar == null) {
            return Container(height: CalendarConstants.tileHeight);
          }
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [weeklyCalendar, Divider(height: 1)]);
        }),
      ],
    );
  }
}
