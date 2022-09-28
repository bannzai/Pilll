import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/organisms/calendar/day/calendar_day_tile.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/domain/menstruation_edit/components/calendar/month_calendar_state.codegen.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page_state.codegen.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page_state_notifier.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/material.dart';

abstract class CalendarConstants {
  static const double tileHeight = 66;
  static const int maxLineCount = 6;
}

class MonthCalendar extends HookConsumerWidget {
  final DateTime dateForMonth;
  final MenstruationEditPageState state;
  final MonthCalendarState monthCalendarState;
  final MenstruationEditPageStateNotifier store;

  const MonthCalendar({
    Key? key,
    required this.dateForMonth,
    required this.state,
    required this.monthCalendarState,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeks = monthCalendarState.weeks;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
              Weekday.values.length,
              (index) => Expanded(
                    child: WeekdayBadge(
                      weekday: Weekday.values[index],
                    ),
                  )),
        ),
        const Divider(height: 1),
        ...List.generate(6, (offset) {
          if (weeks.length <= offset) {
            return Container(height: CalendarConstants.tileHeight);
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CalendarWeekLine(
                dateRange: weeks[offset],
                calendarMenstruationBandModels: const [],
                calendarScheduledMenstruationBandModels: const [],
                calendarNextPillSheetBandModels: const [],
                horizontalPadding: 0,
                day: (context, weekday, date) {
                  return CalendarDayTile(
                      weekday: weekday,
                      date: date,
                      showsDiaryMark: false,
                      showsScheduleMark: false,
                      showsMenstruationMark: () {
                        final menstruation = state.menstruation;
                        if (menstruation == null) {
                          return false;
                        }
                        return DateRange(menstruation.beginDate, menstruation.endDate).inRange(date);
                      }(),
                      onTap: (date) {
                        analytics.logEvent(name: "selected_day_tile_on_menstruation_edit");
                        store.tappedDate(date, state.setting);
                      });
                },
              ),
              const Divider(height: 1),
            ],
          );
        }),
      ],
    );
  }
}
