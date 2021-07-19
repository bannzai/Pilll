import 'package:pilll/components/organisms/calendar/monthly/calendar_state.dart';
import 'package:pilll/domain/calendar/weekly_calendar_state.dart';
import 'package:pilll/components/organisms/calendar/weekly/weekly_calendar_state.dart';

class CalendarTabState extends MonthlyCalendarState {
  final DateTime dateForMonth;
  CalendarTabState(this.dateForMonth);

  WeeklyCalendarState weeklyCalendarState(int line) {
    return CalendarTabWeeklyCalendarState(
      dateRangeOfLine(line),
      dateForMonth,
    );
  }
}
