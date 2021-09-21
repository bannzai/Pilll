import 'dart:math';

import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
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
  if (setting.pillNumberForFromMenstruation == 0) {
    return [];
  }
  assert(maxPageCount > 0);

  final List<DateRange> dateRanges = [];
  // 大体の数を計算
  final count = max(maxPageCount, pillSheetGroup.pillSheets.length) /
      pillSheetGroup.pillSheets.length;
  for (int i = 0; i < count; i++) {
    final offset = pillSheetGroup.totalPillCountIntoGroup * i;
    for (int pageIndex = 0;
        pageIndex < pillSheetGroup.pillSheets.length;
        pageIndex++) {
      final pillSheet = pillSheetGroup.pillSheets[pageIndex];
      final pillSheetTypes =
          pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();
      final passedCount = passedTotalCount(
          pillSheetTypes: pillSheetTypes, pageIndex: pageIndex);
      final serializedPillNumber = passedCount + pillSheet.typeInfo.totalCount;
      if (serializedPillNumber < setting.pillNumberForFromMenstruation) {
        continue;
      }

      final diff = setting.pillNumberForFromMenstruation - passedCount;
      final begin =
          pillSheet.beginingDate.add(Duration(days: (diff - 1) + offset));
      final end = begin.add(Duration(days: (setting.durationMenstruation - 1)));
      final isContained = menstruations
          .where((element) =>
              element.dateRange.inRange(begin) ||
              element.dateRange.inRange(end))
          .isNotEmpty;
      if (isContained) {
        continue;
      }

      dateRanges.add(DateRange(begin, end));
      if (dateRanges.length >= count) {
        return dateRanges;
      }
    }
  }
  return dateRanges;
}

List<DateRange> nextPillSheetDateRanges(
  PillSheetGroup pillSheetGroup,
  int maxPageCount,
) {
  if (pillSheetGroup.pillSheets.isEmpty) {
    return [];
  }
  assert(maxPageCount > 0);

  // 大体の数を計算
  final count = max(maxPageCount, pillSheetGroup.pillSheets.length) /
      pillSheetGroup.pillSheets.length;
  return List.generate(count.toInt(), (groupPageIndex) {
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
