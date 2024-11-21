import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/molecules/shadow_container.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/day/calendar_day_tile.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/features/menstruation/data.dart';
import 'package:pilll/features/menstruation/menstruation_page.dart';
import 'package:pilll/features/record/weekday_badge.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/entity/weekday.dart';

const double _horizontalPadding = 10;

class MenstruationCalendarHeader extends StatelessWidget {
  final List<CalendarMenstruationBandModel> calendarMenstruationBandModels;
  final List<CalendarScheduledMenstruationBandModel> calendarScheduledMenstruationBandModels;
  final List<CalendarNextPillSheetBandModel> calendarNextPillSheetBandModels;
  final List<Diary> diaries;
  final List<Schedule> schedules;
  final PageController pageController;

  const MenstruationCalendarHeader(
      {super.key,
      required this.calendarMenstruationBandModels,
      required this.calendarScheduledMenstruationBandModels,
      required this.calendarNextPillSheetBandModels,
      required this.diaries,
      required this.schedules,
      required this.pageController});

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Container(
        padding: const EdgeInsets.only(
          left: _horizontalPadding,
          right: _horizontalPadding,
        ),
        width: MediaQuery.of(context).size.width,
        height: MenstruationPageConst.calendarHeaderHeight,
        child: Column(
          children: [
            _WeekdayLine(),
            LimitedBox(
              maxHeight: MenstruationPageConst.tileHeight,
              child: PageView.builder(
                controller: pageController,
                physics: const PageScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final days = menstruationWeekCalendarDataSource[index];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width - _horizontalPadding * 2,
                    height: MenstruationPageConst.tileHeight,
                    child: CalendarWeekLine(
                      dateRange: DateRange(days.first, days.last),
                      horizontalPadding: _horizontalPadding,
                      day: (context, weekday, date) {
                        return CalendarDayTile(
                            weekday: weekday,
                            date: date,
                            diary: diaries.firstWhereOrNull((e) => isSameDay(e.date, date)),
                            schedule: schedules.firstWhereOrNull((e) => isSameDay(e.date, date)),
                            onTap: (date) {
                              analytics.logEvent(name: "did_select_day_tile_on_menstruation");
                              transitionWhenCalendarDayTapped(context, date: date, diaries: diaries, schedules: schedules);
                            });
                      },
                      calendarMenstruationBandModels: calendarMenstruationBandModels,
                      calendarNextPillSheetBandModels: calendarNextPillSheetBandModels,
                      calendarScheduledMenstruationBandModels: calendarScheduledMenstruationBandModels,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekdayLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(Weekday.values.length, (index) => Expanded(child: WeekdayBadge(weekday: Weekday.values[index]))),
    );
  }
}
