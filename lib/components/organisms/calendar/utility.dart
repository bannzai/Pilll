import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/weekday.dart';

List<DateRange> scheduledOrInTheMiddleMenstruationDateRanges(
  PillSheetGroup pillSheetGroup,
  Setting setting,
  List<Menstruation> menstruations,
  int maxPageCount,
) {
  if (pillSheetGroup.pillSheets.isEmpty) {
    return [];
  }
  assert(maxPageCount > 0);

  return List.generate(maxPageCount, (groupPageIndex) {
    final offset = groupPageIndex * pillSheetGroup.totalPillCountIntoGroup;
    return pillSheetGroup.pillSheets.map((pillSheet) {
      if (pillSheet.typeInfo.totalCount <
          setting.pillNumberForFromMenstruation) {
        return null;
      }
      final begin = pillSheet.beginingDate.add(
          Duration(days: (setting.pillNumberForFromMenstruation - 1) + offset));
      final end = begin.add(Duration(days: (setting.durationMenstruation - 1)));
      final isContained = menstruations
          .where((element) =>
              element.dateRange.inRange(begin) ||
              element.dateRange.inRange(end))
          .isNotEmpty;
      if (isContained) {
        return null;
      }
      return DateRange(begin, end);
    }).whereType<DateRange>();
  }).expand((element) => element).toList();
}

List<DateRange> nextPillSheetDateRanges(
  PillSheetGroup pillSheetGroup,
  int maxPageCount,
) {
  if (pillSheetGroup.pillSheets.isEmpty) {
    return [];
  }
  assert(maxPageCount > 0);
  return List.generate(maxPageCount, (groupPageIndex) {
    return pillSheetGroup.pillSheets.map((pillSheet) {
      final offset = groupPageIndex * pillSheetGroup.totalPillCountIntoGroup;
      final begin = pillSheet.scheduledLastTakenDate.add(Duration(days: 1));
      final end = begin.add(Duration(days: Weekday.values.length - 1));
      return DateRange(
          begin.add(Duration(days: offset)), end.add(Duration(days: offset)));
    });
  }).expand((element) => element).toList();
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
  PillSheetGroup? pillSheetGroup,
  Setting? setting,
  List<Menstruation> menstruations,
  int maxPageCount,
) {
  assert(maxPageCount > 0);
  return [
    ...menstruations.map((e) => CalendarMenstruationBandModel(e)),
    if (pillSheetGroup != null) ...[
      ...scheduledOrInTheMiddleMenstruationDateRanges(
              pillSheetGroup, setting!, menstruations, maxPageCount)
          .where((bandRange) => menstruations
              .where((menstruation) =>
                  bandRange.inRange(menstruation.beginDate) ||
                  bandRange.inRange(menstruation.endDate))
              .isEmpty)
          .map((range) =>
              CalendarScheduledMenstruationBandModel(range.begin, range.end)),
      ...nextPillSheetDateRanges(pillSheetGroup, maxPageCount).map(
          (range) => CalendarNextPillSheetBandModel(range.begin, range.end))
    ]
  ];
}
