import 'package:flutter/material.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar_state.dart';
import 'package:pilll/entity/diary.codegen.dart';

class CalendarTabWeekCalendarState extends WeekCalendarState {
  final DateRange dateRange;
  final List<Diary> diariesForMonth;
  final DateTime targetDateOfMonth;

  CalendarTabWeekCalendarState({
    required this.dateRange,
    required this.diariesForMonth,
    required this.targetDateOfMonth,
  });

  bool isGrayoutTile(DateTime date) => date.isPreviousMonth(targetDateOfMonth);
  bool hasDiaryMark(List<Diary> diaries, DateTime date) =>
      isExistsPostedDiary(diaries, date);
  bool hasMenstruationMark(DateTime date) => false;
  Alignment get contentAlignment => Alignment.center;
}
