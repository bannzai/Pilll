import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

abstract class CalendarState {
  DateTime get date;

  DateTime dateTimeForFirstDayOfMonth() {
    return DateTime(date.year, date.month, 1);
  }

  DateTime dateTimeForPreviousMonthTile(int offset) {
    var dateTimeForLastDayOfPreviousMonth = DateTime(date.year, date.month, 0);
    var lastDayForPreviousMonthWeekdayIndex =
        WeekdayFunctions.weekdayFromDate(dateTimeForLastDayOfPreviousMonth)
            .index;
    return DateTime(
        dateTimeForLastDayOfPreviousMonth.year,
        dateTimeForLastDayOfPreviousMonth.month,
        dateTimeForLastDayOfPreviousMonth.day -
            lastDayForPreviousMonthWeekdayIndex +
            offset);
  }

  int lastDay() => DateTime(date.year, date.month + 1, 0).day;
  int _weekdayOffset() =>
      WeekdayFunctions.weekdayFromDate(dateTimeForFirstDayOfMonth()).index;
  int _previousMonthDayCount() => _weekdayOffset();
  int tileCount() => _previousMonthDayCount() + lastDay();
  int lineCount() => (tileCount() / 7).ceil();

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
        DateTime(date.year, date.month, lastDay()),
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

  bool notInRangeAtLine(int line, DateTime date) {
    var range = dateRangeOfLine(line);
    return !range.inRange(date.date());
  }

  int offsetForStartPositionAtLine(int line, DateTime begin) {
    var range = dateRangeOfLine(line);
    var isLineBreaked = notInRangeAtLine(line, begin);
    return isLineBreaked
        ? 0
        : begin.date().difference(range.begin.date()).inDays;
  }

  bool shouldGrayOutTile(Weekday weekday, int line);
  bool shouldFillEmptyTile(Weekday weekday, int day);
  bool shouldShowDiaryMark(List<Diary> diaries, int day);
  int targetDay(Weekday weekday, int line);
}

class MonthlyCalendarState extends CalendarState {
  final DateTime date;

  MonthlyCalendarState(this.date);
  bool shouldGrayOutTile(Weekday weekday, int line) =>
      weekday.index < _weekdayOffset() && line == 1;
  bool shouldFillEmptyTile(Weekday weekday, int day) => day > lastDay();
  bool shouldShowDiaryMark(List<Diary> diaries, int day) {
    return diaries
        .where((element) =>
            isSameDay(element.date, DateTime(date.year, date.month, day)))
        .isNotEmpty;
  }

  int targetDay(Weekday weekday, int line) {
    return (line - 1) * Weekday.values.length +
        weekday.index -
        _weekdayOffset() +
        1;
  }
}
