import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/components/organisms/calendar/week/utility.dart';
import 'package:pilll/database/diary.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/domain/calendar/week_calendar_state.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:riverpod/riverpod.dart';

part 'month_calendar_state.codegen.freezed.dart';

final monthCalendarStateProvider =
    Provider.family<AsyncValue<MonthCalendarState>, DateTime>(
        (ref, DateTime dateForMonth) {
  final diaries = ref.watch(diariesStreamForMonthProvider(dateForMonth));
  final menstruations =
      ref.watch(menstruationsStreamForMonthProvider(dateForMonth));

  try {
    return AsyncValue.data(
      MonthCalendarState(
        dateForMonth: dateForMonth,
        diaries: diaries.asData?.value ?? [],
        menstruations: menstruations.asData?.value ?? [],
      ),
    );
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace: stackTrace);
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

  late final WeekCalendarDateRangeCalculator _range =
      WeekCalendarDateRangeCalculator(dateForMonth);

  List<CalendarTabWeeklyCalendarState> get weekCalendarStatuses =>
      List.generate(_range.weeklineCount(), (index) => index + 1)
          .map(
            (line) => CalendarTabWeeklyCalendarState(
              dateRange: _range.dateRangeOfLine(line),
              diariesForMonth: diaries,
              targetDateOfMonth: dateForMonth,
            ),
          )
          .toList();
}
