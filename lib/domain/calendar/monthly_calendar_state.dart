import 'package:pilll/components/organisms/calendar/monthly/calendar_state.dart';
import 'package:pilll/domain/calendar/weekly_calendar_state.dart';
import 'package:pilll/components/organisms/calendar/weekly/weekly_calendar_state.dart';
import 'package:pilll/entity/menstruation.dart';

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

class MenstruationEditCalendarState extends MonthlyCalendarState {
  final DateTime dateForMonth;
  final Menstruation? menstruation;
  MenstruationEditCalendarState(this.dateForMonth, this.menstruation);

  WeeklyCalendarState weeklyCalendarState(int line) {
    return MenstruationEditWeeklyCalendarState(
      dateRangeOfLine(line),
      dateForMonth,
      menstruation,
    );
  }
}
