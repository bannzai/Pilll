import 'package:flutter/material.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar_state.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';

class MenstruationEditWeekCalendarState extends WeekCalendarState {
  @override
  final DateRange dateRange;
  final DateTime dateForMonth;
  final Menstruation? menstruation;

  @override
  List<Diary> get diariesForMonth => [];

  MenstruationEditWeekCalendarState({
    required this.dateRange,
    required this.dateForMonth,
    required this.menstruation,
  });

  @override
  bool isGrayoutTile(DateTime date) => date.isPreviousMonth(dateForMonth);
  @override
  bool showsDiaryMark(List<Diary> diaries, DateTime date) => false;
  @override
  bool showsMenstruationMark(DateTime date) {
    final menstruation = this.menstruation;
    if (menstruation == null) {
      return false;
    }
    return DateRange(menstruation.beginDate, menstruation.endDate).inRange(date);
  }

  @override
  Alignment get contentAlignment => Alignment.center;
}
