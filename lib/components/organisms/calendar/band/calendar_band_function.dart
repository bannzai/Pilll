import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/utils/datetime/day.dart';

// 予定されている生理日 or 記録されている生理日の日付の配列を返す
// maxDateRangeCountは主にユニットテストの時に嬉しい引数になっているがプロダクションコードでもそのまま使用している
// ユースケースとして大体の未来のものを返せれば良いので厳密な計算結果が欲しいわけではないので動作確認とユニットテストをしやすい方式をとっている
List<DateRange> scheduledOrInTheMiddleMenstruationDateRanges(PillSheetGroup? pillSheetGroup, Setting? setting, List<Menstruation> menstruations,
    [int maxDateRangeCount = 15]) {
  if (pillSheetGroup == null || setting == null) {
    return [];
  }
  if (pillSheetGroup.pillSheets.isEmpty) {
    return [];
  }
  if (setting.pillNumberForFromMenstruation == 0) {
    return [];
  }
  assert(maxDateRangeCount > 0);

  final menstruationDateRanges = menstruations.map((e) => e.dateRange);
  final scheduledMenstruationDateRanges = pillSheetGroup.menstruationDateRanges(setting: setting).where((scheduledMenstruationRange) {
    // すでに記録されている生理については除外したものを予定されている生理とする
    return menstruationDateRanges
        .where((menstruationDateRange) =>
            menstruationDateRange.inRange(scheduledMenstruationRange.begin) || menstruationDateRange.inRange(scheduledMenstruationRange.end))
        .isEmpty;
  }).toList();
  final baseDateRanges = scheduledMenstruationDateRanges..addAll(menstruationDateRanges);

  List<DateRange> dateRanges = baseDateRanges;
  final pillSheetGroupTotalPillCount = pillSheetGroup.pillSheetTypes.fold(0, (p, e) => p + e.typeInfo.totalCount);
  for (var i = 1; i <= maxDateRangeCount; i++) {
    final offset = pillSheetGroupTotalPillCount * i;
    final dateRangesWithOffset =
        baseDateRanges.map((e) => DateRange(e.begin.add(Duration(days: offset)), e.end.add(Duration(days: offset)))).toList();
    dateRanges = dateRanges..addAll(dateRangesWithOffset);
  }

  if (dateRanges.length > maxDateRangeCount) {
    // maxDateRangeCount分だけ返す。主にテストの時に結果を予想しやすいのでこの形をとっている
    return dateRanges.sublist(0, maxDateRangeCount);
  } else {
    return dateRanges;
  }
}

List<DateRange> nextPillSheetDateRanges(PillSheetGroup pillSheetGroup, [int maxDateRangeCount = 15]) {
  if (pillSheetGroup.pillSheets.isEmpty) {
    return [];
  }
  assert(maxDateRangeCount > 0);

  final totalPillCount = pillSheetGroup.pillSheets.map((e) => e.pillSheetType.totalCount).reduce((value, element) => value + element);
  var dateRanges = <DateRange>[];
  for (int i = 0; i < maxDateRangeCount; i++) {
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
