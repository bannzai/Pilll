import 'package:flutter/material.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar_state.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';

class MenstruationSinglelineWeekCalendarState extends WeekCalendarState {
  @override
  final DateRange dateRange;
  @override
  final List<Diary> diariesForMonth;
  final List<CalendarBandModel> allBandModels;
  MenstruationSinglelineWeekCalendarState({
    required this.dateRange,
    required this.diariesForMonth,
    required this.allBandModels,
  });

  @override
  bool isGrayoutTile(DateTime date) => false;
  @override
  bool showsDiaryMark(List<Diary> diaries, DateTime date) => isExistsPostedDiary(diaries, date);
  @override
  bool showsScheduleMark(List<Schedule> schedules, DateTime date) => isExistsSchedule(schedules, date);
  @override
  bool showsMenstruationMark(DateTime date) => false;
  @override
  Alignment get contentAlignment => Alignment.center;
}
