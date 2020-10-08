import 'package:Pilll/main/calendar/date_range.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/weekday.dart';

DateRange menstruationDateRange(
  PillSheetModel pillSheet,
  Setting setting,
  int page,
) {
  var offset = page * pillSheet.pillSheetType.totalCount;
  var begin = pillSheet.beginingDate.add(Duration(
      days: (pillSheet.pillSheetType.dosingPeriod - 1) +
          (setting.fromMenstruation + 1) +
          offset));
  var end = begin.add(Duration(days: (setting.durationMenstruation - 1)));
  return DateRange(begin, end);
}

DateRange nextPillSheetDateRange(
  PillSheetModel pillSheet,
  int page,
) {
  var begin = pillSheet.beginingDate
      .add(Duration(days: pillSheet.pillSheetType.totalCount * (page + 1)));
  var end = begin.add(Duration(days: Weekday.values.length));
  return DateRange(begin, end);
}
