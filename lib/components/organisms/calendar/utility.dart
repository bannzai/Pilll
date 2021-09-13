import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/weekday.dart';
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
  assert(maxPageCount > 0);
  return List.generate(maxPageCount, (pageIndex) {
    final offset = pageIndex * pillSheetGroup.totalPillCountIntoGroup;

    final DateTime begin;
    if (setting.isOnSequenceAppearance) {
      final serializedTodayPillNumber =
          pillSheetGroup.serializedTodayPillNumber;
      if (serializedTodayPillNumber != null) {
        if (serializedTodayPillNumber <=
            setting.pillNumberForFromMenstruation) {
          // Left side todayPillNumber from setting.pillNumberFromMenstruation
          final diff =
              setting.pillNumberForFromMenstruation - serializedTodayPillNumber;
          begin = today().add(Duration(days: diff));
        } else {
          // Avoid very dirty indent
          final _left = setting.pillNumberForFromMenstruation;
          final _target = serializedTodayPillNumber;
          final _right = setting.pillNumberForFromMenstruation +
              setting.durationMenstruation;

          if (_left <= _target && _target <= _right) {
            // In the middle pattern
            final diff = serializedTodayPillNumber -
                setting.pillNumberForFromMenstruation;
            begin = today().subtract(Duration(days: diff));
          } else {
            // Right side todayPillNumber from setting.pillNumberFromMenstruation
            begin = today().add(Duration(
                days: pillSheetGroup.remainPillCount +
                    setting.pillNumberForFromMenstruation));
          }
        }
      } else {
        // PillSheetGroup does not have actived pillSheet
        // The lastTakenPillSheet is always present here as it is checking for empty pillSheets in the function above
        begin = pillSheetGroup.latestTakenPillSheet!.beginingDate
            .add(Duration(days: pillSheetGroup.remainPillCount));
      }
    } else {}

    final end = begin.add(Duration(days: (setting.durationMenstruation - 1)));
    final isContained = menstruations
        .where((element) =>
            element.dateRange.inRange(begin) || element.dateRange.inRange(end))
        .isNotEmpty;
    if (isContained) {
      return null;
    }
    return DateRange(
        begin.add(Duration(days: offset)), end.add(Duration(days: offset)));
  }).where((element) => element != null).toList().cast();
}

List<DateRange> nextPillSheetDateRanges(
  PillSheetGroup pillSheetGroup,
  int maxPageCount,
) {
  assert(maxPageCount > 0);
  return List.generate(maxPageCount, (pageIndex) {
    final remainPillCount = pillSheetGroup.remainPillCount;
    final offset = pageIndex * pillSheetGroup.totalPillCountIntoGroup;
    final begin = today().add(Duration(days: remainPillCount));
    final end = begin.add(Duration(days: Weekday.values.length - 1));
    return DateRange(
        begin.add(Duration(days: offset)), end.add(Duration(days: offset)));
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
