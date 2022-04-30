import 'package:flutter/material.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

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

abstract class WeeklyCalendarState {
  DateRange get dateRange;
  List<Diary> get diariesForMonth;
  List<CalendarBandModel> get allBandModels;

  bool isGrayoutTile(DateTime date);
  bool hasDiaryMark(List<Diary> diaries, DateTime date);
  bool hasMenstruationMark(DateTime date);
  Alignment get contentAlignment;

  bool isNecessaryLineBreak(DateTime date) {
    return !dateRange.inRange(date.date());
  }

  int offsetForStartPositionAtLine(DateTime begin) {
    return isNecessaryLineBreak(begin)
        ? 0
        : daysBetween(dateRange.begin.date(), begin.date());
  }

  DateTime buildDate(Weekday weekday) {
    return dateRange.begin.add(Duration(days: weekday.index));
  }

  int targetDay(Weekday weekday) {
    return dateRange.begin.add(Duration(days: weekday.index + 1)).day;
  }
}
