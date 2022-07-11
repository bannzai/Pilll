import 'package:pilll/entity/menstruation.codegen.dart';

abstract class CalendarBandModel {
  final DateTime begin;
  final DateTime end;
  CalendarBandModel(this.begin, this.end);
}

class CalendarScheduledMenstruationBandModel extends CalendarBandModel {
  CalendarScheduledMenstruationBandModel(DateTime begin, DateTime end)
      : super(begin, end);
}

class CalendarMenstruationBandModel extends CalendarBandModel {
  final Menstruation menstruation;
  CalendarMenstruationBandModel(this.menstruation)
      : super(menstruation.beginDate, menstruation.endDate);
}

class CalendarNextPillSheetBandModel extends CalendarBandModel {
  CalendarNextPillSheetBandModel(DateTime begin, DateTime end)
      : super(begin, end);
}
