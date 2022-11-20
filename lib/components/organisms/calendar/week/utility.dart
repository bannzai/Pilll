import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/features/calendar/date_range.dart';
import 'package:pilll/entity/weekday.dart';

class WeekCalendarDateRangeCalculator {
  final DateTime dateForMonth;

  WeekCalendarDateRangeCalculator(this.dateForMonth);

  DateRange dateRangeOfLine(int line) {
    if (line == 1) {
      return DateRange(
        DateTime(dateForMonth.year, dateForMonth.month, 1 - _previousMonthDayCount()),
        DateTime(dateForMonth.year, dateForMonth.month, Weekday.values.length - _previousMonthDayCount()),
      );
    }
    if (line == weeklineCount()) {
      return DateRange(
        DateTime(dateForMonth.year, dateForMonth.month, Weekday.values.length * (line - 1) + 1 - _previousMonthDayCount()),
        DateTime(dateForMonth.year, dateForMonth.month, _lastDay()),
      );
    }
    var beginDay = Weekday.values.length * (line - 1) - _previousMonthDayCount() + 1;
    var endDay = Weekday.values.length * line - _previousMonthDayCount();
    return DateRange(
      DateTime(dateForMonth.year, dateForMonth.month, beginDay),
      DateTime(dateForMonth.year, dateForMonth.month, endDay),
    );
  }

  int _lastDay() => DateTime(dateForMonth.year, dateForMonth.month + 1, 0).day;
  int _weekdayOffset() => WeekdayFunctions.weekdayFromDate(_firstDayOfMonth(dateForMonth)).index;
  int _previousMonthDayCount() => _weekdayOffset();
  int _tileCount() => _previousMonthDayCount() + _lastDay();
  int weeklineCount() => (_tileCount() / Weekday.values.length).ceil();

  DateTime _firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
}

bool _isPostedDiary(Diary diary, DateTime date) => isSameDay(diary.date, date);
bool _isPostedSchedule(Schedule schedule, DateTime date) => isSameDay(schedule.date, date);
bool isExistsPostedDiary(List<Diary> diaries, DateTime date) => diaries.where((element) => _isPostedDiary(element, date)).isNotEmpty;
bool isExistsSchedule(List<Schedule> schedules, DateTime date) => schedules.where((element) => _isPostedSchedule(element, date)).isNotEmpty;

extension DateTimeForCalnedarState on DateTime {
  bool isPreviousMonth(DateTime date) {
    if (isSameMonth(date, this)) {
      return false;
    }
    return isBefore(date);
  }
}
