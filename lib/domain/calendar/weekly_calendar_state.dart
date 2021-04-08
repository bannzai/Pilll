import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/menstruation.dart';
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

bool isPostedDiary(Diary diary, DateTime date) => isSameDay(diary.date, date);
bool isExistsPostedDiary(List<Diary> diaries, DateTime date) =>
    diaries.where((element) => isPostedDiary(element, date)).isNotEmpty;

abstract class WeeklyCalendarState {
  DateRange get dateRange;

  bool shouldGrayoutTile(DateTime date);
  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date);
  bool shouldShowMenstruationMark(DateTime date);

  bool isNecessaryLineBreak(DateTime date) {
    return !dateRange.inRange(date.date());
  }

  int offsetForStartPositionAtLine(DateTime begin) {
    return isNecessaryLineBreak(begin)
        ? 0
        : begin.date().difference(dateRange.begin.date()).inDays;
  }

  DateTime buildDate(Weekday weekday) {
    return dateRange.begin.add(Duration(days: weekday.index));
  }

  int targetDay(Weekday weekday) {
    return dateRange.begin.add(Duration(days: weekday.index + 1)).day;
  }
}

class SinglelineWeeklyCalendarState extends WeeklyCalendarState {
  final DateRange dateRange;
  SinglelineWeeklyCalendarState(this.dateRange);

  bool shouldGrayoutTile(DateTime date) => false;
  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date) =>
      isExistsPostedDiary(diaries, date);
  bool shouldShowMenstruationMark(DateTime date) => false;
}

class MultilineWeeklyCalendarState extends WeeklyCalendarState {
  final DateRange dateRange;
  final DateTime targetDateOfMonth;

  MultilineWeeklyCalendarState(this.dateRange, this.targetDateOfMonth);

  bool shouldGrayoutTile(DateTime date) =>
      date._isPreviousMonth(targetDateOfMonth);
  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date) =>
      isExistsPostedDiary(diaries, date);
  bool shouldShowMenstruationMark(DateTime date) => false;
}

class MenstruationEditWeeklyCalendarState extends WeeklyCalendarState {
  final DateRange dateRange;
  final DateTime targetDateOfMonth;
  final Menstruation? menstruation;

  MenstruationEditWeeklyCalendarState(
      this.dateRange, this.targetDateOfMonth, this.menstruation);

  bool shouldGrayoutTile(DateTime date) =>
      date._isPreviousMonth(targetDateOfMonth);
  bool shouldShowDiaryMark(List<Diary> diaries, DateTime date) => false;
  bool shouldShowMenstruationMark(DateTime date) {
    final menstruation = this.menstruation;
    if (menstruation == null) {
      return false;
    }
    return DateRange(menstruation.beginDate, menstruation.endDate)
        .inRange(date);
  }
}
