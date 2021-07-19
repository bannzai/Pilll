import 'package:flutter/material.dart';
import 'package:pilll/components/organisms/calendar/weekly/weekly_calendar_state.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/menstruation.dart';

class MenstruationEditWeeklyCalendarState extends WeeklyCalendarState {
  final DateRange dateRange;
  final DateTime targetDateOfMonth;
  final Menstruation? menstruation;

  MenstruationEditWeeklyCalendarState(
      this.dateRange, this.targetDateOfMonth, this.menstruation);

  bool isGrayoutTile(DateTime date) => date.isPreviousMonth(targetDateOfMonth);
  bool hasDiaryMark(List<Diary> diaries, DateTime date) => false;
  bool hasMenstruationMark(DateTime date) {
    final menstruation = this.menstruation;
    if (menstruation == null) {
      return false;
    }
    return DateRange(menstruation.beginDate, menstruation.endDate)
        .inRange(date);
  }

  Alignment get contentAlignment => Alignment.center;
}
