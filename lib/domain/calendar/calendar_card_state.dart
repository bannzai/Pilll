import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/monthly/calendar_state.dart';
import 'package:pilll/entity/diary.dart';

class CalendarCardState extends MonthlyCalendarState {
  final DateTime dateForMonth;
  final List<Diary> diariesForMonth;
  final List<CalendarBandModel> allBands;
  CalendarCardState(this.dateForMonth, this.diariesForMonth, this.allBands);
}
