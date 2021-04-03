import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/domain/calendar/calendar_date_header.dart';
import 'package:pilll/domain/calendar/monthly_calendar_state.dart';
import 'package:pilll/util/datetime/day.dart';

class MenstruationEditPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // final store = useProvider(menstruationEditProvider(entity));
    // final state = useProvider(menstruationEditProvider(entity).state);
    final currentMonth = today();
    final nextMonth = DateTime(today().year, today().month + 1, today().day);
    return ListView(
      children: [
        CalendarDateHeader(date: currentMonth),
        Calendar(
          calendarState: MonthlyCalendarState(currentMonth),
          bandModels: [],
          horizontalPadding: 0,
        ),
        CalendarDateHeader(date: nextMonth),
        Calendar(
          calendarState: MonthlyCalendarState(nextMonth),
          bandModels: [],
          horizontalPadding: 0,
        ),
      ],
    );
  }
}
