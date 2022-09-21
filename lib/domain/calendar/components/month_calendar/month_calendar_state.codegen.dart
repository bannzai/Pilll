import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/components/organisms/calendar/week/utility.dart';
import 'package:pilll/database/diary.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/database/schedule.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:riverpod/riverpod.dart';

part 'month_calendar_state.codegen.freezed.dart';

final monthCalendarStateProvider = Provider.family<AsyncValue<MonthCalendarState>, DateTime>((ref, DateTime dateForMonth) {
  final diaries = ref.watch(diariesStreamForMonthProvider(dateForMonth));
  final schedules = ref.watch(schedulesProvider(dateForMonth));
  final menstruations = ref.watch(menstruationsStreamForMonthProvider(dateForMonth));

  try {
    return AsyncValue.data(
      MonthCalendarState(
        dateForMonth: dateForMonth,
        diaries: diaries.asData?.value ?? [],
        schedules: schedules.asData?.value ?? [],
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
    required List<Schedule> schedules,
    required List<Menstruation> menstruations,
  }) = _MonthCalendarState;
  MonthCalendarState._();

  WeekCalendarDateRangeCalculator get _range => WeekCalendarDateRangeCalculator(dateForMonth);
  late List<DateRange> weeks = List.generate(_range.weeklineCount(), (index) => index + 1).map((line) => _range.dateRangeOfLine(line)).toList();
}
