import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/domain/calendar/weekly_calendar_state.dart';
import 'package:pilll/entity/weekday.dart';

DateTime _firstDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month, 1);
}

abstract class MonthlyCalendarState {
  DateTime get dateForMonth;
  DateRange dateRangeOfLine(int line) {
    if (line == 1) {
      return DateRange(
        DateTime(dateForMonth.year, dateForMonth.month,
            1 - _previousMonthDayCount()),
        DateTime(dateForMonth.year, dateForMonth.month,
            Weekday.values.length - _previousMonthDayCount()),
      );
    }
    if (line == lineCount()) {
      return DateRange(
        DateTime(dateForMonth.year, dateForMonth.month,
            Weekday.values.length * (line - 1) + 1 - _previousMonthDayCount()),
        DateTime(dateForMonth.year, dateForMonth.month, _lastDay()),
      );
    }
    var beginDay =
        Weekday.values.length * (line - 1) - _previousMonthDayCount() + 1;
    var endDay = Weekday.values.length * line - _previousMonthDayCount();
    return DateRange(
      DateTime(dateForMonth.year, dateForMonth.month, beginDay),
      DateTime(dateForMonth.year, dateForMonth.month, endDay),
    );
  }

  int _lastDay() => DateTime(dateForMonth.year, dateForMonth.month + 1, 0).day;
  int _weekdayOffset() =>
      WeekdayFunctions.weekdayFromDate(_firstDayOfMonth(dateForMonth)).index;
  int _previousMonthDayCount() => _weekdayOffset();
  int _tileCount() => _previousMonthDayCount() + _lastDay();
  int lineCount() => (_tileCount() / Weekday.values.length).ceil();
  WeeklyCalendarState weeklyCalendarState(int line);
}

class CalendarTabState extends MonthlyCalendarState {
  final DateTime dateForMonth;
  CalendarTabState(this.dateForMonth);

  WeeklyCalendarState weeklyCalendarState(int line) {
    return MultilineWeeklyCalendarState(
      dateRangeOfLine(line),
      dateForMonth,
    );
  }
}
