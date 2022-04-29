import 'package:collection/collection.dart';

import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/day/calendar_day_tile.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_function.dart';
import 'package:pilll/components/organisms/calendar/weekly/weekly_calendar_state.dart';
import 'package:pilll/domain/diary/post_diary_page.dart';
import 'package:flutter/material.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/domain/diary/confirm_diary_sheet.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

class CalendarWeekdayLine extends StatelessWidget {
  final WeekCalendarState state;
  final double horizontalPadding;
  final Function(WeekCalendarState, DateTime) onTap;

  const CalendarWeekdayLine({
    Key? key,
    required this.state,
    required this.horizontalPadding,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Row(
            children: Weekday.values.map((weekday) {
              final date = state.buildDate(weekday);
              final isOutOfBoundsInLine = !state.dateRange.inRange(date);
              if (isOutOfBoundsInLine) {
                return Expanded(child: Container());
              }

              if (state.isGrayoutTile(date)) {
                return CalendarDayTile.grayout(
                  weekday: weekday,
                  shouldShowMenstruationMark: state.hasMenstruationMark(date),
                  contentAlignment: state.contentAlignment,
                  date: date,
                );
              }
              return CalendarDayTile(
                isToday: isSameDay(today(), date),
                weekday: weekday,
                date: date,
                shouldShowDiaryMark:
                    state.hasDiaryMark(state.diariesForMonth, date),
                shouldShowMenstruationMark: state.hasMenstruationMark(date),
                contentAlignment: state.contentAlignment,
                onTap: (date) => onTap(state, date),
              );
            }).toList(),
          ),
          ..._bands(context, state.allBandModels, state, horizontalPadding)
        ],
      ),
    );
  }

  List<Widget> _bands(
    BuildContext context,
    List<CalendarBandModel> bandModels,
    WeekCalendarState calendarState,
    double horizontalPadding,
  ) {
    var tileWidth =
        (MediaQuery.of(context).size.width - horizontalPadding * 2) /
            Weekday.values.length;

    return bandModels
        .map((bandModel) {
          final isInRange = calendarState.dateRange.inRange(bandModel.begin) ||
              calendarState.dateRange.inRange(bandModel.end);
          if (!isInRange) {
            return null;
          }

          bool isLineBreaked =
              calendarState.isNecessaryLineBreak(bandModel.begin);
          int start =
              calendarState.offsetForStartPositionAtLine(bandModel.begin);
          final length =
              bandLength(calendarState.dateRange, bandModel, isLineBreaked);

          return Positioned(
            left: start.toDouble() * tileWidth,
            width: tileWidth * length,
            bottom: bandModel.bottom,
            child: CalendarBand(
              model: bandModel,
              isLineBreaked: isLineBreaked,
              width: tileWidth * length,
              onTap: (model) {
                if (model is! CalendarMenstruationBandModel) {
                  return;
                }
                showMenstruationEditPageForUpdate(context, model.menstruation);
              },
            ),
          );
        })
        .whereNotNull()
        .toList();
  }
}

void transitionToPostDiary(
  BuildContext context,
  DateTime date,
  List<Diary> diaries,
) {
  if (date.isAfter(today())) {
    return;
  }
  if (!isExistsPostedDiary(diaries, date)) {
    Navigator.of(context).push(PostDiaryPageRoute.route(date, null));
  } else {
    final diary = diaries.lastWhere((element) => isSameDay(element.date, date));
    showModalBottomSheet(
      context: context,
      builder: (context) => ConfirmDiarySheet(diary),
      backgroundColor: Colors.transparent,
    );
  }
}
