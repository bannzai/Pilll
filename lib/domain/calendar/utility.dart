import 'package:Pilll/domain/calendar/calendar_band_model.dart';
import 'package:Pilll/domain/calendar/date_range.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/entity/pill_sheet_type.dart';
import 'package:Pilll/entity/setting.dart';
import 'package:Pilll/entity/weekday.dart';

DateRange menstruationDateRange(
  PillSheetModel pillSheet,
  Setting setting,
  int page,
) {
  var offset = page * pillSheet.pillSheetType.totalCount;
  var begin = pillSheet.beginingDate.add(
      Duration(days: (setting.pillNumberForFromMenstruation - 1) + offset));
  var end = begin.add(Duration(days: (setting.durationMenstruation - 1)));
  return DateRange(begin, end);
}

DateRange nextPillSheetDateRange(
  PillSheetModel pillSheet,
  int page,
) {
  var begin = pillSheet.beginingDate
      .add(Duration(days: pillSheet.pillSheetType.totalCount * (page + 1)));
  var end = begin.add(Duration(days: Weekday.values.length - 1));
  return DateRange(begin, end);
}

List<CalendarBandModel> buildBandModels(
  PillSheetModel pillSheet,
  Setting setting,
  int page,
) {
  if (pillSheet == null) {
    return [];
  }
  List<CalendarBandModel> bandModels = [];
  final menstruation = menstruationDateRange(pillSheet, setting, 0);
  if (menstruation != null) {
    bandModels.add(menstruation
        .map((range) => CalendarMenstruationBandModel(range.begin, range.end)));
  }
  bandModels.add(nextPillSheetDateRange(pillSheet, 0)
      .map((range) => CalendarNextPillSheetBandModel(range.begin, range.end)));
  return bandModels;
}
