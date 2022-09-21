import 'package:flutter/material.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/util/datetime/date_compare.dart';

bool _isPostedDiary(Diary diary, DateTime date) => isSameDay(diary.date, date);
bool _isPostedSchedule(Schedule schedule, DateTime date) => isSameDay(schedule.date, date);
bool isExistsPostedDiary(List<Diary> diaries, DateTime date) => diaries.where((element) => _isPostedDiary(element, date)).isNotEmpty;
bool isExistsSchedule(List<Schedule> schedules, DateTime date) => schedules.where((element) => _isPostedSchedule(element, date)).isNotEmpty;

extension DateTimeForCalnedarState on DateTime {
  bool isPreviousMonth(DateTime date) {
    if (isSameMonth(date, this)) {
      return false;
    }
    return isBefore(date);
  }
}
