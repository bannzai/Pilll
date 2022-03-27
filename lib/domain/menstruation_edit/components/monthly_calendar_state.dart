import 'package:pilll/components/organisms/calendar/monthly/calendar_state.dart';
import 'package:pilll/entity/menstruation.dart';

class MenstruationEditCalendarState extends MonthlyCalendarState {
  final DateTime dateForMonth;
  final Menstruation? menstruation;
  MenstruationEditCalendarState(this.dateForMonth, this.menstruation);
}
