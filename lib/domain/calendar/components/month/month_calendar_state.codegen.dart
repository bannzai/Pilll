import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/components/organisms/calendar/weekly/weekly_calendar_state.dart';
import 'package:pilll/database/diary.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/domain/calendar/week_calendar_state.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:riverpod/riverpod.dart';

part 'month_calendar_state.codegen.freezed.dart';

final monthCalendarStateProvider =
    Provider.family<AsyncValue<MonthCalendarState>, DateTime>(
        (ref, DateTime dateForMonth) {
  final diaries = ref.watch(diariesStreamForMonthProvider(dateForMonth));
  final menstruations =
      ref.watch(menstruationsStreamForMonthProvider(dateForMonth));

  if (diaries is AsyncLoading || menstruations is AsyncLoading) {
    return const AsyncValue.loading();
  }

  try {
    return AsyncValue.data(
      MonthCalendarState(
        dateForMonth: dateForMonth,
        diaries: diaries.value!,
        menstruations: menstruations.value!,
      ),
    );
  } catch (error, _) {
    return AsyncValue.error(error);
  }
});

@freezed
class MonthCalendarState with _$MonthCalendarState {
  factory MonthCalendarState({
    required DateTime dateForMonth,
    required List<Diary> diaries,
    required List<Menstruation> menstruations,
  }) = _MonthCalendarState;
  MonthCalendarState._();

  List<CalendarTabWeeklyCalendarState> get weekCalendarStatuses =>
      List.generate(weeklineCount(), (index) => index + 1)
          .map(
            (line) => CalendarTabWeeklyCalendarState(
              dateRange: _dateRangeOfLine(line),
              diariesForMonth: diaries,
              // TODO:
              allBandModels: [],
              targetDateOfMonth: dateForMonth,
            ),
          )
          .toList();

  DateRange _dateRangeOfLine(int line) {
    if (line == 1) {
      return DateRange(
        DateTime(dateForMonth.year, dateForMonth.month,
            1 - _previousMonthDayCount()),
        DateTime(dateForMonth.year, dateForMonth.month,
            Weekday.values.length - _previousMonthDayCount()),
      );
    }
    if (line == weeklineCount()) {
      return DateRange(
        DateTime(dateForMonth.year, dateForMonth.month,
            Weekday.values.length * (line - 1) + 1 - _previousMonthDayCount()),
        DateTime(dateForMonth.year, dateForMonth.month, _lastDay()),
      );
    }
    var beginDay =
        Weekday.values.length * (line - 1) - _previousMonthDayCount() + 1;
    var endDay = Weekday.values.length * line - _previousMonthDayCount();
    return DateRange(
      DateTime(dateForMonth.year, dateForMonth.month, beginDay),
      DateTime(dateForMonth.year, dateForMonth.month, endDay),
    );
  }

  int _lastDay() => DateTime(dateForMonth.year, dateForMonth.month + 1, 0).day;
  int _weekdayOffset() =>
      WeekdayFunctions.weekdayFromDate(_firstDayOfMonth(dateForMonth)).index;
  int _previousMonthDayCount() => _weekdayOffset();
  int _tileCount() => _previousMonthDayCount() + _lastDay();
  int weeklineCount() => (_tileCount() / Weekday.values.length).ceil();

  DateTime _firstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }
}
