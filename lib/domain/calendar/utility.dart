import 'package:flutter/material.dart';
import 'package:pilll/domain/calendar/calculator.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/weekday.dart';

DateRange scheduledMenstruationDateRange(
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
  int page,
) {
  if (pillSheet == null) {
    return [];
  }
  return [
    scheduledMenstruationDateRange(pillSheet, setting!, page)
        .map((range) => CalendarMenstruationBandModel(range.begin, range.end)),
    nextPillSheetDateRange(pillSheet, page)
        .map((range) => CalendarNextPillSheetBandModel(range.begin, range.end))
  ];
}

List<Widget> bands(
  BuildContext context,
  List<CalendarBandModel> bandModels,
  Calculator calculator,
  double horizontalPadding,
  int line,
) {
  var range = calculator.dateRangeOfLine(line);
  return bandModels
      .map((bandModel) {
        final isInRange =
            range.inRange(bandModel.begin) || range.inRange(bandModel.end);
        if (!isInRange) {
          return null;
        }
        bool isLineBreaked = calculator.notInRangeAtLine(line, bandModel.begin);
        int start =
            calculator.offsetForStartPositionAtLine(line, bandModel.begin);

        final length = bandLength(range, bandModel, isLineBreaked);
        var tileWidth =
            (MediaQuery.of(context).size.width - horizontalPadding * 2) /
                Weekday.values.length;
        return Positioned(
          left: start.toDouble() * tileWidth,
          width: tileWidth * length,
          bottom: 0,
          height: 15,
          child: CalendarBand(model: bandModel, isLineBreaked: isLineBreaked),
        );
      })
      .where((element) => element != null)
      .toList()
      .cast();
}
