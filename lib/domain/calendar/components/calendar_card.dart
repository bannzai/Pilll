import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/shadow_container.dart';
import 'package:pilll/components/organisms/calendar/monthly/monthly_calendar_layout.dart';
import 'package:pilll/components/organisms/calendar/weekly/weekly_calendar.dart';
import 'package:pilll/domain/calendar/calendar_card_state.dart';
import 'package:pilll/domain/calendar/weekly_calendar_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarCard extends StatelessWidget {
  final CalendarCardState state;
  const CalendarCard({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: MonthlyCalendarLayout(
        state: state,
        weeklyCalendarBuilder: (context, weeklyDateRange) {
          final diaries = state.diariesForMonth;
          return CalendarWeekdayLine(
            calendarState: CalendarTabWeeklyCalendarState(
              dateRange: weeklyDateRange,
              diariesForMonth: diaries,
              allBandModels: state.allBands,
              targetDateOfMonth: state.dateForMonth,
            ),
            horizontalPadding: 0,
            onTap: (weeklyCalendarState, date) {
              analytics.logEvent(name: "did_select_day_tile_on_calendar_card");
              transitionToPostDiary(context, date, diaries);
            },
          );
        },
      ),
    );
  }
}
