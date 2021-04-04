import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

extension DateTimeForCalnedarState on DateTime {
  bool _isPreviousMonth(DateTime date) {
    if (isSameMonth(date, this)) {
      return false;
    }
    return this.isBefore(date);
  }
}

abstract class WeeklyCalendarState {
  DateRange get dateRange;

  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date);
  bool isNecessaryLineBreak(DateTime date) {
    return !dateRange.inRange(date.date());
  }

  int offsetForStartPositionAtLine(DateTime begin) {
    return isNecessaryLineBreak(begin)
        ? 0
        : begin.date().difference(dateRange.begin.date()).inDays;
  }

  bool shouldGrayoutTile(DateTime date);
  DateTime buildDate(Weekday weekday) {
    return dateRange.begin.add(Duration(days: weekday.index));
  }

  int targetDay(Weekday weekday) {
    return dateRange.begin.add(Duration(days: weekday.index + 1)).day;
  }
}

class SinglelineWeeklyCalendarState extends WeeklyCalendarState {
  final DateRange dateRange;

  bool shouldGrayoutTile(DateTime date) => false;
  SinglelineWeeklyCalendarState(this.dateRange);
  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date) {
    return diaries.where((element) => isSameDay(element.date, date)).isNotEmpty;
  }
}

class MultilineWeeklyCalendarState extends WeeklyCalendarState {
  final DateRange dateRange;
  final DateTime targetDateOfMonth;

  MultilineWeeklyCalendarState(this.dateRange, this.targetDateOfMonth);

  bool shouldGrayoutTile(DateTime date) =>
      date._isPreviousMonth(targetDateOfMonth);
  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date) {
    return diaries.where((element) => isSameDay(element.date, date)).isNotEmpty;
  }
}

class MenstruationEditWeeklyCalendarState extends WeeklyCalendarState {
  final DateRange dateRange;
  final DateTime targetDateOfMonth;

  MenstruationEditWeeklyCalendarState(this.dateRange, this.targetDateOfMonth);

  bool shouldGrayoutTile(DateTime date) =>
      date._isPreviousMonth(targetDateOfMonth);
  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date) => false;
}
