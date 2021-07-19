import 'package:pilll/components/organisms/calendar/monthly/calendar_state.dart';
import 'package:pilll/components/organisms/calendar/weekly/weekly_calendar_state.dart';
import 'package:pilll/domain/menstruation_edit/components/calendar/weekly_calendar_state.dart';
import 'package:pilll/entity/menstruation.dart';

class MenstruationEditCalendarState extends MonthlyCalendarState {
  final DateTime dateForMonth;
  final Menstruation? menstruation;
  MenstruationEditCalendarState(this.dateForMonth, this.menstruation);

  WeeklyCalendarState weeklyCalendarState(int line) {
    return MenstruationEditWeeklyCalendarState(
      dateRangeOfLine(line),
      dateForMonth,
      menstruation,
    );
  }
}
