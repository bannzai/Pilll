import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/organisms/calendar/weekly/weekly_calendar_state.dart';
import 'package:pilll/domain/calendar/components/month/month_calendar_state.codegen.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/material.dart';

abstract class CalendarConstants {
  static const double tileHeight = 66;
  static const int maxLineCount = 6;
}

class MonthlyCalendarLayout extends HookConsumerWidget {
  final DateTime dateForMonth;
  final Widget Function(BuildContext, MonthCalendarState, WeekCalendarState)
      weekCalendarBuilder;

  const MonthlyCalendarLayout({
    Key? key,
    required this.dateForMonth,
    required this.weekCalendarBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(monthCalendarStateProvider(dateForMonth));

    return state.when(
      data: (state) {
        final weekCalendarStatuses = state.weekCalendarStatuses;

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
              if (weekCalendarStatuses.length <= offset) {
                return Container(height: CalendarConstants.tileHeight);
              }

              final weeklyCalendar = weekCalendarBuilder(
                  context, state, weekCalendarStatuses[offset]);
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weeklyCalendar,
                  const Divider(height: 1),
                ],
              );
            }),
          ],
        );
      },
      error: (error, _) => Container(
        child: Text(error.toString()),
      ),
      loading: () => const Indicator(),
    );
  }
}
