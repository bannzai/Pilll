import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';

List<DateRange> scheduledOrInTheMiddleMenstruationDateRanges(PillSheetGroup? pillSheetGroup, Setting? setting, List<Menstruation> menstruations,
    [int maxPageCount = 15]) {
  if (pillSheetGroup == null || setting == null) {
    return [];
  }
  if (pillSheetGroup.pillSheets.isEmpty) {
    return [];
  }
  if (setting.pillNumberForFromMenstruation == 0) {
    return [];
  }
  assert(maxPageCount > 0);

  final totalPillCount = pillSheetGroup.pillSheets.map((e) => e.pillSheetType.totalCount).reduce((value, element) => value + element);
  final List<DateRange> dateRanges = [];
  // 大体の数を計算
  for (int i = 0; i < maxPageCount; i++) {
    final offset = totalPillCount * i;

    for (int pageIndex = 0; pageIndex < pillSheetGroup.pillSheets.length; pageIndex++) {
      final pillSheet = pillSheetGroup.pillSheets[pageIndex];
      final passedCount = summarizedPillCountWithPillSheetTypesToIndex(pillSheetTypes: pillSheetGroup.pillSheetTypes, toIndex: pageIndex);
      final serializedTotalPillNumber = passedCount + pillSheet.typeInfo.totalCount;
      if (serializedTotalPillNumber < setting.pillNumberForFromMenstruation) {
        continue;
      }

      final int menstruationNumber;
      if (passedCount == 0) {
        menstruationNumber = setting.pillNumberForFromMenstruation;
      } else {
        menstruationNumber = setting.pillNumberForFromMenstruation % passedCount;
      }

      if (menstruationNumber > pillSheet.pillSheetType.totalCount) {
        continue;
      }

      final begin = pillSheet.beginingDate.add(Duration(days: (menstruationNumber - 1) + offset));
      final end = begin.add(Duration(days: (setting.durationMenstruation - 1)));
      final isRealMenstruationDurationContained =
          menstruations.where((element) => element.dateRange.inRange(begin) || element.dateRange.inRange(end)).isNotEmpty;
      if (isRealMenstruationDurationContained) {
        continue;
      }
      final isAlreadyContained = dateRanges.where((element) => isSameDay(element.begin, begin) || isSameDay(element.end, end)).isNotEmpty;
      if (isAlreadyContained) {
        continue;
      }

      dateRanges.add(DateRange(begin, end));
      if (dateRanges.length >= maxPageCount) {
        return dateRanges;
      }
    }
  }
  return dateRanges;
}

List<DateRange> nextPillSheetDateRanges(PillSheetGroup pillSheetGroup, [int maxPageCount = 15]) {
  if (pillSheetGroup.pillSheets.isEmpty) {
    return [];
  }
  assert(maxPageCount > 0);

  final totalPillCount = pillSheetGroup.pillSheets.map((e) => e.pillSheetType.totalCount).reduce((value, element) => value + element);
  var dateRanges = <DateRange>[];
  for (int i = 0; i < maxPageCount; i++) {
    final offset = totalPillCount * i;
    for (var pillSheet in pillSheetGroup.pillSheets) {
      final begin = pillSheet.estimatedEndTakenDate.add(Duration(days: 1 + offset));
      final end = begin.add(Duration(days: Weekday.values.length - 1));
      dateRanges.add(DateRange(begin, end));
    }
  }
  return dateRanges;
}

int bandLength(DateRange range, CalendarBandModel bandModel, bool isLineBreaked) {
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

bool isNecessaryLineBreak(DateTime date, DateRange dateRange) {
  return !dateRange.inRange(date.date());
}

int offsetForStartPositionAtLine(DateTime begin, DateRange dateRange) {
  return isNecessaryLineBreak(begin, dateRange) ? 0 : daysBetween(dateRange.begin.date(), begin.date());
}
