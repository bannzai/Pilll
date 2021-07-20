import 'package:flutter/material.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/components/organisms/calendar/weekly/weekly_calendar_state.dart';
import 'package:pilll/entity/diary.dart';

class MenstruationSinglelineWeeklyCalendarState extends WeeklyCalendarState {
  final DateRange dateRange;
  final List<Diary> diariesForMonth;
  final List<CalendarBandModel> allBandModels;
  MenstruationSinglelineWeeklyCalendarState({
    required this.dateRange,
    required this.diariesForMonth,
    required this.allBandModels,
  });

  bool isGrayoutTile(DateTime date) => false;
  bool hasDiaryMark(List<Diary> diaries, DateTime date) =>
      isExistsPostedDiary(diaries, date);
  bool hasMenstruationMark(DateTime date) => false;
  Alignment get contentAlignment => Alignment.center;
}
