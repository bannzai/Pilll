import 'package:pilll/domain/calendar/calendar_band.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/domain/calendar/calendar_day_tile.dart';
import 'package:pilll/domain/calendar/utility.dart';
import 'package:pilll/domain/calendar/weekly_calendar_state.dart';
import 'package:pilll/domain/diary/post_diary_page.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/domain/diary/confirm_diary_sheet.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

class CalendarWeekdayLine extends StatelessWidget {
  final List<Diary> diaries;
  final WeeklyCalendarState calendarState;
  final List<CalendarBandModel> bandModels;
  final double horizontalPadding;
  final Function(WeeklyCalendarState, DateTime) onTap;

  const CalendarWeekdayLine({
    Key? key,
    required this.diaries,
    required this.calendarState,
    required this.bandModels,
    required this.horizontalPadding,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: Weekday.values.map((weekday) {
            final date = calendarState.buildDate(weekday);
            final isOutOfBoundsInLine = !calendarState.dateRange.inRange(date);
            if (isOutOfBoundsInLine) {
              return Expanded(child: Container());
            }

            if (calendarState.shouldGrayoutTile(date)) {
              return CalendarDayTile(
                isToday: false,
                onTap: null,
                weekday: weekday,
                hasDiary: false,
                isIntoMenstruationDuration:
                    calendarState.isIntoMenstruationDuration(date),
                date: date,
              );
            }
            return CalendarDayTile(
              isToday: isSameDay(today(), date),
              weekday: weekday,
              date: date,
              hasDiary: calendarState.shouldShowDiaryMark(diaries, date),
              isIntoMenstruationDuration:
                  calendarState.isIntoMenstruationDuration(date),
              onTap: (date) => onTap(calendarState, date),
            );
          }).toList(),
        ),
        ..._bands(context, bandModels, calendarState, horizontalPadding)
      ],
    );
  }

  List<Widget> _bands(
    BuildContext context,
    List<CalendarBandModel> bandModels,
    WeeklyCalendarState calendarState,
    double horizontalPadding,
  ) {
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
          var tileWidth =
              (MediaQuery.of(context).size.width - horizontalPadding * 2) /
                  Weekday.values.length;
          return Positioned(
            left: start.toDouble() * tileWidth,
            width: tileWidth * length,
            bottom: bandModel.bottom,
            child: CalendarBand(
              model: bandModel,
              isLineBreaked: isLineBreaked,
              width: tileWidth * length,
            ),
          );
        })
        .where((element) => element != null)
        .toList()
        .cast();
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
    Navigator.of(context).push(PostDiaryPageRoute.route(date));
  } else {
    showModalBottomSheet(
      context: context,
      builder: (context) => ConfirmDiarySheet(date),
      backgroundColor: Colors.transparent,
    );
  }
}
