import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/components/organisms/calendar/week/utility.dart';
import 'package:pilll/domain/menstruation_edit/components/calendar/week_calendar_state.dart';
import 'package:pilll/entity/menstruation.codegen.dart';

part 'month_calendar_state.codegen.freezed.dart';

@freezed
class MonthCalendarState with _$MonthCalendarState {
  factory MonthCalendarState({
    required DateTime dateForMonth,
    required Menstruation? menstruation,
  }) = _MonthCalendarState;
  MonthCalendarState._();

  late final WeekCalendarDateRangeCalculator _range =
      WeekCalendarDateRangeCalculator(dateForMonth);

  List<MenstruationEditWeekCalendarState> get weekCalendarStatuses =>
      List.generate(_range.weeklineCount(), (index) => index + 1)
          .map(
            (line) => MenstruationEditWeekCalendarState(
              dateRange: _range.dateRangeOfLine(line),
              dateForMonth: dateForMonth,
              menstruation: menstruation,
            ),
          )
          .toList();
}
