import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

abstract class WeeklyCalendarState {
  DateRange get dateRange;

  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date);
  bool isNecessaryLineBreak(DateTime date) {
    return !dateRange.inRange(date.date());
  }

  int offsetForStartPositionAtLine(DateTime begin) {
    var isLineBreaked = isNecessaryLineBreak(begin);
    return isLineBreaked
        ? 0
        : begin.date().difference(dateRange.begin.date()).inDays;
  }

  DateTime? dateTimeForGrayoutTile(DateTime date);
  DateTime buildDate(Weekday weekday) {
    return dateRange.begin.add(Duration(days: weekday.index));
  }

  int targetDay(Weekday weekday) {
    return dateRange.begin.add(Duration(days: weekday.index + 1)).day;
  }
}

class SinglelineWeeklyCalendarState extends WeeklyCalendarState {
  final DateRange dateRange;

  DateTime? dateTimeForGrayoutTile(DateTime date) => null;
  SinglelineWeeklyCalendarState(this.dateRange);
  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date) => false;
}

class MultilineCalendarState extends WeeklyCalendarState {
  final DateRange dateRange;
  final DateTime targetDateOfMonth;

  MultilineCalendarState(this.dateRange, this.targetDateOfMonth);

  DateTime? dateTimeForGrayoutTile(DateTime date) {
    if (_shouldGrayOutTile(date)) {
      return null;
    }
    final offset = WeekdayFunctions.weekdayFromDate(date).index;
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

  bool _shouldGrayOutTile(DateTime date) =>
      isSameMonth(date, targetDateOfMonth);
  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date) {
    return diaries.where((element) => isSameDay(element.date, date)).isNotEmpty;
  }
}
