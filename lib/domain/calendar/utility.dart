import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/weekday.dart';

List<DateRange> scheduledMenstruationDateRanges(
  PillSheetModel pillSheet,
  Setting setting,
  int maxPageCount,
) {
  return List.generate(maxPageCount + 1, (pageIndex) {
    final offset = pageIndex + pillSheet.pillSheetType.totalCount;
    final begin = pillSheet.beginingDate.add(
        Duration(days: (setting.pillNumberForFromMenstruation - 1) + offset));
    final end = begin.add(Duration(days: (setting.durationMenstruation - 1)));
    return DateRange(begin, end);
  });
}

List<DateRange> nextPillSheetDateRanges(
  PillSheetModel pillSheet,
  int maxPageCount,
) {
  return List.generate(maxPageCount, (pageIndex) {
    final begin = pillSheet.beginingDate.add(
        Duration(days: pillSheet.pillSheetType.totalCount * (pageIndex + 1)));
    final end = begin.add(Duration(days: Weekday.values.length - 1));
    return DateRange(begin, end);
  });
}

int bandLength(
    DateRange range, CalendarBandModel bandModel, bool isLineBreaked) {
  return range
          .union(
            DateRange(
              isLineBreaked ? range.begin : bandModel.begin,
              bandModel.end,
            ),
          )
          .days +
      1;
}

List<CalendarBandModel> buildBandModels(
  PillSheetModel? pillSheet,
  Setting? setting,
  List<Menstruation> menstruations,
  int page,
) {
  return [
    if (pillSheet != null) ...[
      scheduledMenstruationDateRanges(pillSheet, setting!, page).map(
          (range) => CalendarMenstruationBandModel(range.begin, range.end)),
      nextPillSheetDateRanges(pillSheet, page).map(
          (range) => CalendarNextPillSheetBandModel(range.begin, range.end))
    ]
  ];
}
