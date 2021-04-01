import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/domain/calendar/weekly_calendar_state.dart';
import 'package:pilll/entity/weekday.dart';

class MonthlyCalendarState {
  final DateTime date;

  DateRange dateRangeOfLine(int line) {
    if (line == 1) {
      return DateRange(
        DateTime(date.year, date.month, 1 - _previousMonthDayCount()),
        DateTime(date.year, date.month,
            Weekday.values.length - _previousMonthDayCount()),
      );
    }
    if (line == lineCount()) {
      return DateRange(
        DateTime(date.year, date.month,
            Weekday.values.length * (line - 1) + 1 - _previousMonthDayCount()),
        DateTime(date.year, date.month, _lastDay()),
      );
    }
    var beginDay =
        Weekday.values.length * (line - 1) - _previousMonthDayCount() + 1;
    var endDay = Weekday.values.length * line - _previousMonthDayCount();
    return DateRange(
      DateTime(date.year, date.month, beginDay),
      DateTime(date.year, date.month, endDay),
    );
  }

  int _lastDay() => DateTime(date.year, date.month + 1, 0).day;
  int _weekdayOffset() =>
      WeekdayFunctions.weekdayFromDate(_firstDayOfMonth(date)).index;
  int _previousMonthDayCount() => _weekdayOffset();
  int _tileCount() => _previousMonthDayCount() + _lastDay();
  int lineCount() => (_tileCount() / Weekday.values.length).ceil();

  MonthlyCalendarState(this.date);

  WeeklyCalendarState weeklyCalendarState(int line) {
    return MultilineCalendarState(
      dateRangeOfLine(line),
      date,
    );
  }
}

DateTime _firstDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month, 1);
}
