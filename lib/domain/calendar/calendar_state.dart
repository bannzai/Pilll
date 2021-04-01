import 'dart:isolate';

import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

abstract class CalendarState {
  bool shouldGrayOutTile(Weekday weekday, int line);
  bool shouldFillEmptyTile(Weekday weekday, int day);
  bool shouldShowDiaryMark(List<Diary> diaries, int day);
  int targetDay(Weekday weekday, int line);
  DateTime? dateTimeForPreviousMonthTile(Weekday weekday, int line);
  bool isToday(int day);
  DateTime buildDate(Weekday weekday);

  DateRange dateRangeOfLine(int line);
  bool notInRangeAtLine(int line, DateTime date);
  int offsetForStartPositionAtLine(int line, DateTime begin);
}

class MonthlyCalendarState extends CalendarState {
  final DateTime date;
  DateTime dateTimeForFirstDayOfMonth() {
    return DateTime(date.year, date.month, 1);
  }

  DateTime? dateTimeForPreviousMonthTile(Weekday weekday, int line) {
    if (!shouldGrayOutTile(weekday, line)) {
      return null;
    }
    int offset = weekday.index;
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

  int _lastDay() => DateTime(date.year, date.month + 1, 0).day;
  int _weekdayOffset() =>
      WeekdayFunctions.weekdayFromDate(dateTimeForFirstDayOfMonth()).index;
  int _previousMonthDayCount() => _weekdayOffset();
  int _tileCount() => _previousMonthDayCount() + _lastDay();
  int lineCount() => (_tileCount() / 7).ceil();

  MonthlyCalendarState(this.date);
  bool shouldGrayOutTile(Weekday weekday, int line) =>
      weekday.index < _weekdayOffset() && line == 1;
  bool shouldFillEmptyTile(Weekday weekday, int day) => day > _lastDay();
  bool shouldShowDiaryMark(List<Diary> diaries, int day) {
    return diaries
        .where((element) =>
            isSameDay(element.date, DateTime(date.year, date.month, day)))
        .isNotEmpty;
  }

  bool isToday(int day) =>
      isSameDay(today(), DateTime(date.year, date.month, day));

  int targetDay(Weekday weekday, int line) {
    return (line - 1) * Weekday.values.length +
        weekday.index -
        _weekdayOffset() +
        1;
  }

  DateTime buildDate(Weekday weekday) {
    return DateTime(date.year, date.month, targetDay(weekday, 1));
  }
}

class WeeklyCalendarState extends CalendarState {
  final DateRange dateRange;

  DateTime? dateTimeForPreviousMonthTile(Weekday weekday, int line) => null;
  WeeklyCalendarState(this.dateRange);
  bool shouldGrayOutTile(Weekday weekday, int line) => false;
  bool shouldFillEmptyTile(Weekday weekday, int day) => false;
  bool shouldShowDiaryMark(List<Diary> diaries, int day) {
    throw UnimplementedError();
  }

  bool isToday(int day) => dateRange
      .list()
      .map((e) => isSameDay(DateTime(e.year, e.month, day), e))
      .contains(true);

  int targetDay(Weekday weekday, int line) {
    return Weekday.values.length + weekday.index - 1;
  }

  DateTime buildDate(Weekday weekday) {
    return dateRange.list()[weekday.index];
  }

  DateRange dateRangeOfLine(int line) {
    throw UnimplementedError();
  }

  bool notInRangeAtLine(int line, DateTime date) {
    throw UnimplementedError();
  }

  int offsetForStartPositionAtLine(int line, DateTime begin) {
    throw UnimplementedError();
  }
}
