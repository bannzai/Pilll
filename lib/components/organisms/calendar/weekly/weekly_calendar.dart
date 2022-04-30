import 'package:pilll/analytics.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band.dart';

import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_menstruation_band.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_next_pill_sheet_band.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_scheduled_menstruation_band.dart';
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
  final List<CalendarMenstruationBandModel> calendarMenstruationBandModels;
  final List<CalendarScheduledMenstruationBandModel>
      calendarScheduledMenstruationBandModels;
  final List<CalendarNextPillSheetBandModel> calendarNextPillSheetBandModels;
  final Function(WeekCalendarState, DateTime) onTap;

  const CalendarWeekdayLine({
    Key? key,
    required this.state,
    required this.calendarMenstruationBandModels,
    required this.calendarScheduledMenstruationBandModels,
    required this.calendarNextPillSheetBandModels,
    required this.horizontalPadding,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var tileWidth =
        (MediaQuery.of(context).size.width - horizontalPadding * 2) /
            Weekday.values.length;
    return Container(
      child: Stack(
        children: [
          Row(
            children: Weekday.values.map((weekday) {
              final date = _buildDate(weekday);
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
          ...calendarMenstruationBandModels.where(_contains).map(
                (e) => _buildBand(
                  calendarBandModel: e,
                  bottomOffset: 0,
                  tileWidth: tileWidth,
                  bandBuilder: (_, width) => CalendarMenstruationBand(
                    menstruation: e.menstruation,
                    width: width,
                    onTap: (menstruation) {
                      analytics.logEvent(
                          name: "tap_calendar_menstruation_band");
                      showMenstruationEditPage(context,
                          menstruation: menstruation);
                    },
                  ),
                ),
              ),
          ...calendarScheduledMenstruationBandModels.where(_contains).map(
                (e) => _buildBand(
                  calendarBandModel: e,
                  bottomOffset: 0,
                  tileWidth: tileWidth,
                  bandBuilder: (_, width) => CalendarScheduledMenstruationBand(
                    begin: e.begin,
                    end: e.end,
                    width: width,
                  ),
                ),
              ),
          ...calendarNextPillSheetBandModels.where(_contains).map(
                (e) => _buildBand(
                  calendarBandModel: e,
                  bottomOffset: CalendarBandConst.height,
                  tileWidth: tileWidth,
                  bandBuilder: (isLineBreak, width) =>
                      CalendarNextPillSheetBand(
                    begin: e.begin,
                    end: e.end,
                    isLineBreak: isLineBreak,
                    width: width,
                  ),
                ),
              ),
        ],
      ),
    );
  }

  bool _contains(CalendarBandModel calendarBandModel) {
    final isInRange = state.dateRange.inRange(calendarBandModel.begin) ||
        state.dateRange.inRange(calendarBandModel.end);
    return isInRange;
  }

  Widget _buildBand({
    required CalendarBandModel calendarBandModel,
    required double bottomOffset,
    required double tileWidth,
    required Widget Function(bool isLineBreak, double width) bandBuilder,
  }) {
    bool isLineBreak = _isNecessaryLineBreak(calendarBandModel.begin);
    int start = _offsetForStartPositionAtLine(calendarBandModel.begin);
    final length = bandLength(state.dateRange, calendarBandModel, isLineBreak);

    return Positioned(
      left: start.toDouble() * tileWidth,
      width: tileWidth * length,
      bottom: bottomOffset,
      child: bandBuilder(isLineBreak, tileWidth * length),
    );
  }

  bool _isNecessaryLineBreak(DateTime date) {
    return !state.dateRange.inRange(date.date());
  }

  int _offsetForStartPositionAtLine(DateTime begin) {
    return _isNecessaryLineBreak(begin)
        ? 0
        : daysBetween(state.dateRange.begin.date(), begin.date());
  }

  DateTime _buildDate(Weekday weekday) {
    return state.dateRange.begin.add(Duration(days: weekday.index));
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
