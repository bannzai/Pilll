import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

DateTime _firstDayOfMonth(DateTime date) {
  return DateTime(date.year, date.month, 1);
}

abstract class CalendarState {
  DateRange get dateRange;
  bool shouldGrayOutTile(Weekday weekday, int line);
  bool shouldFillEmptyTile(Weekday weekday, int day);
  bool shouldShowDiaryMark(List<Diary> diaries, int day);
  int targetDay(Weekday weekday, int line);
  DateTime? dateTimeForGrayoutTile(Weekday weekday, int line);
  bool isToday(int day);
  DateTime buildDate(Weekday weekday);

  bool notInRangeAtLine(int line, DateTime date);
  int offsetForStartPositionAtLine(int line, DateTime begin);
}

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
      WeekdayFunctions.weekdayFromDate(_firstDayOfMonth(date)).index;
  int _previousMonthDayCount() => _weekdayOffset();
  int lineCount() => 5;

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

  CalendarState weeklyCalendarState(int line) {
    return WeeklyCalendarStateForMonth(
      dateRangeOfLine(line),
      date,
    );
  }
}

class WeeklyCalendarState extends CalendarState {
  final DateRange dateRange;

  DateTime? dateTimeForGrayoutTile(Weekday weekday, int line) => null;
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

  bool notInRangeAtLine(int line, DateTime date) {
    throw UnimplementedError();
  }

  int offsetForStartPositionAtLine(int line, DateTime begin) {
    throw UnimplementedError();
  }
}

class WeeklyCalendarStateForMonth extends CalendarState {
  final DateRange dateRange;
  final DateTime targetDateOfMonth;

  WeeklyCalendarStateForMonth(this.dateRange, this.targetDateOfMonth);

  DateTime? dateTimeForGrayoutTile(Weekday weekday, int line) {
    if (!shouldGrayOutTile(weekday, line)) {
      return null;
    }
    int offset = weekday.index;
    var dateTimeForLastDayOfPreviousMonth =
        DateTime(targetDateOfMonth.year, targetDateOfMonth.month, 0);
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

  bool notInRangeAtLine(int line, DateTime date) {
    return !dateRange.inRange(date.date());
  }

  int offsetForStartPositionAtLine(int line, DateTime begin) {
    var isLineBreaked = notInRangeAtLine(line, begin);
    return isLineBreaked
        ? 0
        : begin.date().difference(dateRange.begin.date()).inDays;
  }

  int _weekdayOffset() =>
      WeekdayFunctions.weekdayFromDate(_firstDayOfMonth(targetDateOfMonth))
          .index;
  int _lastDay() =>
      DateTime(targetDateOfMonth.year, targetDateOfMonth.month + 1, 0).day;

  bool shouldGrayOutTile(Weekday weekday, int line) =>
      weekday.index < _weekdayOffset() && line == 1;
  bool shouldFillEmptyTile(Weekday weekday, int day) => day > _lastDay();
  bool shouldShowDiaryMark(List<Diary> diaries, int day) {
    return diaries
        .where((element) => isSameDay(element.date,
            DateTime(targetDateOfMonth.year, targetDateOfMonth.month, day)))
        .isNotEmpty;
  }

  bool isToday(int day) => isSameDay(
      today(), DateTime(targetDateOfMonth.year, targetDateOfMonth.month, day));

  int targetDay(Weekday weekday, int line) {
    return (line - 1) * Weekday.values.length +
        weekday.index -
        _weekdayOffset() +
        1;
  }

  DateTime buildDate(Weekday weekday) {
    return DateTime(
        targetDateOfMonth.year, targetDateOfMonth.month, targetDay(weekday, 1));
  }
}
