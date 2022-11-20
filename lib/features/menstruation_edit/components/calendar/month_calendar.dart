import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/organisms/calendar/day/calendar_day_tile.dart';
import 'package:pilll/components/organisms/calendar/week/utility.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar.dart';
import 'package:pilll/features/calendar/date_range.dart';
import 'package:pilll/features/record/weekday_badge.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/material.dart';

abstract class CalendarConstants {
  static const double tileHeight = 66;
  static const int maxLineCount = 6;
}

class MonthCalendar extends HookConsumerWidget {
  final DateTime dateForMonth;
  final DateRange? editingDateRange;
  final Function(DateTime) onTap;

  const MonthCalendar({
    Key? key,
    required this.dateForMonth,
    required this.editingDateRange,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeks = _weeks;

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
                        final editingDateRange = this.editingDateRange;
                        if (editingDateRange == null) {
                          return false;
                        }
                        return editingDateRange.inRange(date);
                      }(),
                      onTap: (date) {
                        analytics.logEvent(name: "selected_day_tile_on_menstruation_edit");
                        onTap(date);
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

  WeekCalendarDateRangeCalculator get _range => WeekCalendarDateRangeCalculator(dateForMonth);
  List<DateRange> get _weeks => List.generate(_range.weeklineCount(), (index) => index + 1).map((line) => _range.dateRangeOfLine(line)).toList();
}
