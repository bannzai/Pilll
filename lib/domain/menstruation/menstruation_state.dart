import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/day.dart';

part 'menstruation_state.freezed.dart';

@freezed
abstract class MenstruationState implements _$MenstruationState {
  MenstruationState._();
  factory MenstruationState({
    @Default(true) bool isNotYetLoaded,
    @Default(0) int currentCalendarIndex,
    @Default([]) List<Diary> diariesForMonth,
    @Default([]) List<Menstruation> entities,
    @Default(false) bool isPremium,
    @Default(false) bool isTrial,
    DateTime? trialDeadlineDate,
    Setting? setting,
    PillSheetGroup? latestPillSheetGroup,
  }) = _MenstruationState;

  late final List<List<DateTime>> calendarDataSource = _calendarDataSource();
  int get todayCalendarIndex => calendarDataSource.lastIndexWhere((element) =>
      element.where((element) => isSameDay(element, today())).isNotEmpty);

  DateTime _targetEndDayOfWeekday() {
    final diff = currentCalendarIndex - todayCalendarIndex;
    final base = today().add(Duration(days: diff * Weekday.values.length));
    return endDayOfWeekday(base);
  }

  String get displayMonth =>
      DateTimeFormatter.jaMonth(_targetEndDayOfWeekday());
  String get buttonString {
    final latestMenstruation = this.latestMenstruation;
    if (latestMenstruation == null) {
      return "生理を記録";
    }
    if (latestMenstruation.dateRange.inRange(today())) {
      return "生理期間を編集";
    }
    return "生理を記録";
  }

  Menstruation? get latestMenstruation {
    return entities.isEmpty ? null : entities.first;
  }
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

  var diffDay = DateTimeRange(start: begin, end: end).duration.inDays;
  diffDay += Weekday.values.length - diffDay % Weekday.values.length;
  List<DateTime> days = [];
  for (int i = 0; i < diffDay; i++) {
    days.add(begin.add(Duration(days: i)));
  }
  return List.generate(
      ((diffDay) / Weekday.values.length).round(),
      (i) => days.sublist(i * Weekday.values.length,
          i * Weekday.values.length + Weekday.values.length));
}
