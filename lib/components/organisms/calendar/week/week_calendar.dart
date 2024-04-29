import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/menstruation_edit/components/edit/menstruation_edit_selection_sheet.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band.dart';

import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_menstruation_band.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_next_pill_sheet_band.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_scheduled_menstruation_band.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_function.dart';
import 'package:pilll/components/organisms/calendar/week/utility.dart';
import 'package:pilll/features/calendar/components/diary_or_schedule/diary_or_schedule_sheet.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/features/diary_post/diary_post_page.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/schedule_post/schedule_post_page.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/diary_post/diary_confirmation_sheet.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';

class CalendarWeekLine extends HookConsumerWidget {
  final DateRange dateRange;
  final double horizontalPadding;
  final Widget Function(BuildContext, Weekday, DateTime) day;
  final List<CalendarMenstruationBandModel> calendarMenstruationBandModels;
  final List<CalendarScheduledMenstruationBandModel> calendarScheduledMenstruationBandModels;
  final List<CalendarNextPillSheetBandModel> calendarNextPillSheetBandModels;

  const CalendarWeekLine({
    super.key,
    required this.dateRange,
    required this.horizontalPadding,
    required this.day,
    required this.calendarMenstruationBandModels,
    required this.calendarScheduledMenstruationBandModels,
    required this.calendarNextPillSheetBandModels,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tileWidth = (MediaQuery.of(context).size.width - horizontalPadding * 2) / Weekday.values.length;
    return Stack(
      children: [
        Row(
          children: Weekday.values.map((weekday) {
            final date = _buildDate(weekday);
            final isOutOfBoundsInLine = !dateRange.inRange(date);
            if (isOutOfBoundsInLine) {
              return Expanded(child: Container());
            }

            return day(context, weekday, date);
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
                  onTap: (menstruation) async {
                    analytics.logEvent(name: "tap_calendar_menstruation_band");

                    showMenstruationEditSelectionSheet(
                      context,
                      MenstruationEditSelectionSheet(
                        menstruation: e.menstruation,
                      ),
                    );
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
                bandBuilder: (isLineBreak, width) => CalendarNextPillSheetBand(
                  begin: e.begin,
                  end: e.end,
                  isLineBreak: isLineBreak,
                  width: width,
                ),
              ),
            ),
      ],
    );
  }

  bool _contains(CalendarBandModel calendarBandModel) {
    final isInRange = dateRange.inRange(calendarBandModel.begin) || dateRange.inRange(calendarBandModel.end);
    return isInRange;
  }

  Widget _buildBand({
    required CalendarBandModel calendarBandModel,
    required double bottomOffset,
    required double tileWidth,
    required Widget Function(bool isLineBreak, double width) bandBuilder,
  }) {
    bool isLineBreak = isNecessaryLineBreak(calendarBandModel.begin, dateRange);
    int start = offsetForStartPositionAtLine(calendarBandModel.begin, dateRange);
    final length = bandLength(dateRange, calendarBandModel, isLineBreak);

    return Positioned(
      left: start.toDouble() * tileWidth,
      width: tileWidth * length,
      bottom: bottomOffset,
      child: bandBuilder(isLineBreak, tileWidth * length),
    );
  }

  DateTime _buildDate(Weekday weekday) {
    return dateRange.begin.addDays(weekday.index);
  }
}

void transitionWhenCalendarDayTapped(
  BuildContext context, {
  required DateTime date,
  required List<Diary> diaries,
  required List<Schedule> schedules,
}) {
  if (date.date().isAfter(today())) {
    Navigator.of(context).push(SchedulePostPageRoute.route(date));
    return;
  }

  final diary = diaries.lastWhereOrNull((element) => isSameDay(element.date, date));
  if (isExistsSchedule(schedules, date)) {
    if (diary == null) {
      showModalBottomSheet(
        context: context,
        builder: (context) => DiaryOrScheduleSheet(
            showDiary: () => Navigator.of(context).push(DiaryPostPageRoute.route(date, null)),
            showSchedule: () => Navigator.of(context).push(SchedulePostPageRoute.route(date))),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => DiaryOrScheduleSheet(
            showDiary: () => _showConfirmDiarySheet(context, diary),
            showSchedule: () => Navigator.of(context).push(SchedulePostPageRoute.route(date))),
      );
    }
    return;
  }

  if (diary == null) {
    Navigator.of(context).push(DiaryPostPageRoute.route(date, null));
  } else {
    _showConfirmDiarySheet(context, diary);
  }
}

void _showConfirmDiarySheet(BuildContext context, Diary diary) {
  showModalBottomSheet(
    context: context,
    builder: (context) => DiaryConfirmationSheet(date: diary.date),
    backgroundColor: Colors.transparent,
  );
}
