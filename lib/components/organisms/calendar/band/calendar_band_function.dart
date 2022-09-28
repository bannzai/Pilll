import 'dart:math';

import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

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

  final totalPillCount = pillSheetGroup.pillSheets.map((e) => e.pillSheetType.totalCount).reduce((value, element) => value + element);
  final List<DateRange> dateRanges = [];
  // 大体の数を計算
  for (int i = 0; i < maxPageCount; i++) {
    final offset = totalPillCount * i;
    for (int pageIndex = 0; pageIndex < pillSheetGroup.pillSheets.length; pageIndex++) {
      final pillSheet = pillSheetGroup.pillSheets[pageIndex];
      final pillSheetTypes = pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();
      final passedCount = summarizedPillCountWithPillSheetTypesToEndIndex(pillSheetTypes: pillSheetTypes, endIndex: pageIndex);
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

List<DateRange> nextPillSheetDateRanges(
  PillSheetGroup pillSheetGroup,
  int maxPageCount,
) {
  if (pillSheetGroup.pillSheets.isEmpty) {
    return [];
  }
  assert(maxPageCount > 0);

  // 大体の数を計算
  final totalPillCount = pillSheetGroup.pillSheets.map((e) => e.pillSheetType.totalCount).reduce((value, element) => value + element);
  final count = max(maxPageCount, pillSheetGroup.pillSheets.length) / pillSheetGroup.pillSheets.length;
  return List.generate(count.toInt(), (groupPageIndex) {
    return pillSheetGroup.pillSheets.map((pillSheet) {
      final offset = groupPageIndex * totalPillCount;
      final begin = pillSheet.estimatedEndTakenDate.add(const Duration(days: 1));
      final end = begin.add(Duration(days: Weekday.values.length - 1));
      return DateRange(begin.add(Duration(days: offset)), end.add(Duration(days: offset)));
    });
  }).expand((element) => element).toList();
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
