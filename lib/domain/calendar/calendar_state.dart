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

  bool shouldGrayOutTile(Weekday weekday);
  bool shouldFillEmptyTile(Weekday weekday, DateTime date);
  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date);
  bool isNecessaryLineBreak(DateTime date);

  int offsetForStartPositionAtLine(DateTime begin);

  DateTime? dateTimeForGrayoutTile(Weekday weekday);
  DateTime buildDate(Weekday weekday);

  int targetDay(Weekday weekday) {
    return dateRange.begin.add(Duration(days: weekday.index + 1)).day;
  }
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

  int _lastDay() => DateTime(date.year, date.month + 1, 0).day;
  int _weekdayOffset() =>
      WeekdayFunctions.weekdayFromDate(_firstDayOfMonth(date)).index;
  int _previousMonthDayCount() => _weekdayOffset();
  int lineCount() => 5;

  MonthlyCalendarState(this.date);

  CalendarState weeklyCalendarState(int line) {
    return WeeklyCalendarStateForMonth(
      dateRangeOfLine(line),
      date,
    );
  }
}

class WeeklyCalendarState extends CalendarState {
  final DateRange dateRange;

  DateTime? dateTimeForGrayoutTile(Weekday weekday) => null;
  WeeklyCalendarState(this.dateRange);
  bool shouldGrayOutTile(Weekday weekday) => false;
  bool shouldFillEmptyTile(Weekday weekday, DateTime date) => false;
  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date) {
    throw UnimplementedError();
  }

  DateTime buildDate(Weekday weekday) {
    return dateRange.list()[weekday.index];
  }

  bool isNecessaryLineBreak(DateTime date) {
    throw UnimplementedError();
  }

  int offsetForStartPositionAtLine(DateTime begin) {
    throw UnimplementedError();
  }
}

class WeeklyCalendarStateForMonth extends CalendarState {
  final DateRange dateRange;
  final DateTime targetDateOfMonth;

  WeeklyCalendarStateForMonth(this.dateRange, this.targetDateOfMonth);

  DateTime? dateTimeForGrayoutTile(Weekday weekday) {
    if (!shouldGrayOutTile(weekday)) {
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

  bool isNecessaryLineBreak(DateTime date) {
    return !dateRange.inRange(date.date());
  }

  int offsetForStartPositionAtLine(DateTime begin) {
    var isLineBreaked = isNecessaryLineBreak(begin);
    return isLineBreaked
        ? 0
        : begin.date().difference(dateRange.begin.date()).inDays;
  }

  bool shouldGrayOutTile(Weekday weekday) =>
      weekday.index <
      WeekdayFunctions.weekdayFromDate(_firstDayOfMonth(targetDateOfMonth))
          .index;
  bool shouldFillEmptyTile(Weekday weekday, DateTime date) =>
      date.isAfter(dateRange.end);
  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date) {
    return diaries.where((element) => isSameDay(element.date, date)).isNotEmpty;
  }

  DateTime buildDate(Weekday weekday) {
    return DateTime(
        targetDateOfMonth.year, targetDateOfMonth.month, targetDay(weekday));
  }
}
