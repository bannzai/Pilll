import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/components/organisms/calendar/week/utility.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/menstruation.codegen.dart';

part 'month_calendar_state.codegen.freezed.dart';

@freezed
class MonthCalendarState with _$MonthCalendarState {
  factory MonthCalendarState({
    required DateTime dateForMonth,
    required Menstruation? menstruation,
  }) = _MonthCalendarState;
  MonthCalendarState._();

  late final WeekCalendarDateRangeCalculator _range = WeekCalendarDateRangeCalculator(dateForMonth);
  late final List<DateRange> weeks = List.generate(_range.weeklineCount(), (index) => index + 1).map((line) => _range.dateRangeOfLine(line)).toList();
}
