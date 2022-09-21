import 'package:flutter/material.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar_state.dart';
import 'package:pilll/entity/diary.codegen.dart';

class CalendarTabWeekCalendarState extends WeekCalendarState {
  @override
  final DateRange dateRange;
  @override
  final List<Diary> diariesForMonth;
  final DateTime targetDateOfMonth;

  CalendarTabWeekCalendarState({
    required this.dateRange,
    required this.diariesForMonth,
    required this.targetDateOfMonth,
  });

  @override
  bool isGrayoutTile(DateTime date) => date.isPreviousMonth(targetDateOfMonth);
  @override
  bool showsDiaryMark(List<Diary> diaries, DateTime date) => isExistsPostedDiary(diaries, date);
  @override
  bool showsMenstruationMark(DateTime date) => false;
  @override
  Alignment get contentAlignment => Alignment.center;
}
