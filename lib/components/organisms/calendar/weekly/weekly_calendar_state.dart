import 'package:flutter/material.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/util/datetime/date_compare.dart';

bool isPostedDiary(Diary diary, DateTime date) => isSameDay(diary.date, date);
bool isExistsPostedDiary(List<Diary> diaries, DateTime date) =>
    diaries.where((element) => isPostedDiary(element, date)).isNotEmpty;

extension DateTimeForCalnedarState on DateTime {
  bool isPreviousMonth(DateTime date) {
    if (isSameMonth(date, this)) {
      return false;
    }
    return this.isBefore(date);
  }
}

abstract class WeekCalendarState {
  DateRange get dateRange;
  List<Diary> get diariesForMonth;

  bool isGrayoutTile(DateTime date);
  bool hasDiaryMark(List<Diary> diaries, DateTime date);
  bool hasMenstruationMark(DateTime date);
  Alignment get contentAlignment;
}
