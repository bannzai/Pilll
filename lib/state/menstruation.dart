import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/day.dart';

part 'menstruation.freezed.dart';

@freezed
abstract class MenstruationState implements _$MenstruationState {
  MenstruationState._();
  factory MenstruationState({
    @Default(true) bool isNotYetLoaded,
    @Default(0) int currentCalendarIndex,
    @Default([]) List<Diary> diaries,
    @Default([]) List<Menstruation> entities,
    Setting? setting,
    PillSheetModel? latestPillSheet,
  }) = _MenstruationState;

  late final List<List<DateTime>> calendarDataSource = _calendarDataSource();
  int get todayCalendarIndex => calendarDataSource.length ~/ 2;

  DateTime _targetEndDayOfWeekday() {
    final diff = currentCalendarIndex - todayCalendarIndex;
    final base = today().add(Duration(days: diff * Weekday.values.length));
    return endDayOfWeekday(base);
  }

  String get displayMonth =>
      DateTimeFormatter.jaMonth(_targetEndDayOfWeekday());
}

List<List<DateTime>> _calendarDataSource() {
  final base = today();
  var begin = base.subtract(Duration(days: 90));
  final beginWeekdayOffset = WeekdayFunctions.weekdayFromDate(begin).index;
  begin = begin.subtract(Duration(days: beginWeekdayOffset));

  var end = base.add(Duration(days: 90));
  final endWeekdayOffset =
      Weekday.values.last.index - WeekdayFunctions.weekdayFromDate(end).index;
  end = end.add(Duration(days: endWeekdayOffset));

  final diffDay = DateTimeRange(start: begin, end: end).duration.inDays;
  List<DateTime> days = [];
  for (int i = 0; i < diffDay + 1; i++) {
    days.add(begin.add(Duration(days: i)));
  }
  return List.generate(
      (diffDay / Weekday.values.length).round(),
      (i) => days.sublist(i * Weekday.values.length,
          i * Weekday.values.length + Weekday.values.length));
}
