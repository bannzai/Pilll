import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

part 'menstruation_state.codegen.freezed.dart';

final menstruationCalendarWeekCalendarDataSourceProvider =
    Provider((_) => _calendarDataSource());
final todayCalendarPageIndexProvider = Provider(
  (ref) => ref
      .watch(menstruationCalendarWeekCalendarDataSourceProvider)
      .lastIndexWhere((element) =>
          element.where((element) => isSameDay(element, today())).isNotEmpty),
);
final currentMenstruationWeekCalendarPageIndexProvider =
    Provider((ref) => ref.watch(todayCalendarPageIndexProvider));

@freezed
class MenstruationState with _$MenstruationState {
  MenstruationState._();
  factory MenstruationState({
    required int currentCalendarPageIndex,
    required int todayCalendarPageIndex,
    required List<Diary> diariesForAround90Days,
    required List<Menstruation> menstruations,
    required PremiumAndTrial premiumAndTrial,
    required Setting setting,
    required PillSheetGroup? latestPillSheetGroup,
  }) = _MenstruationState;

  DateTime _targetEndDayOfWeekday() {
    final diff = currentCalendarPageIndex - todayCalendarPageIndex;
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
    return menstruations.isEmpty ? null : menstruations.first;
  }
}

List<List<DateTime>> _calendarDataSource() {
  final base = today();

  var begin = base.subtract(const Duration(days: 90));
  final beginWeekdayOffset = WeekdayFunctions.weekdayFromDate(begin).index;
  begin = begin.subtract(Duration(days: beginWeekdayOffset));

  var end = base.add(const Duration(days: 90));
  final endWeekdayOffset =
      Weekday.values.last.index - WeekdayFunctions.weekdayFromDate(end).index;
  end = end.add(Duration(days: endWeekdayOffset));

  var diffDay = daysBetween(begin, end);
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
