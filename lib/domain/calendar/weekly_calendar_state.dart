import 'package:flutter/material.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/components/organisms/calendar/weekly/weekly_calendar_state.dart';
import 'package:pilll/entity/diary.dart';

class CalendarTabWeeklyCalendarState extends WeeklyCalendarState {
  final DateRange dateRange;
  final DateTime targetDateOfMonth;

  CalendarTabWeeklyCalendarState(this.dateRange, this.targetDateOfMonth);

  bool isGrayoutTile(DateTime date) => date._isPreviousMonth(targetDateOfMonth);
  bool hasDiaryMark(List<Diary> diaries, DateTime date) =>
      isExistsPostedDiary(diaries, date);
  bool hasMenstruationMark(DateTime date) => false;
  Alignment get contentAlignment => Alignment.center;
}
