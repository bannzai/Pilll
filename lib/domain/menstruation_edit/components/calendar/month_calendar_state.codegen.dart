import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/domain/menstruation_edit/components/calendar/weekly_calendar_state.dart';
import 'package:pilll/entity/menstruation.codegen.dart';

part 'month_calendar_state.codegen.codegen.freezed.dart';

@freezed
class MonthCalendarState with _$MonthCalendarState {
  factory MonthCalendarState({
    required List<MenstruationEditWeeklyCalendarState> weekCalendarStatuses,
    required DateTime dateForMonth,
    required Menstruation? menstruation,
  }) = _MonthCalendarState;
  MonthCalendarState._();
}
