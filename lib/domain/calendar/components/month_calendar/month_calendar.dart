import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar_state.dart';
import 'package:pilll/domain/calendar/components/month_calendar/month_calendar_state.codegen.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/material.dart';

abstract class CalendarConstants {
  static const double tileHeight = 66;
  static const int maxLineCount = 6;
}

class MonthCalendar extends HookConsumerWidget {
  final DateTime dateForMonth;
  final Widget Function(BuildContext, MonthCalendarState, WeekCalendarState) weekCalendarBuilder;

  const MonthCalendar({
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

              final weekCalendar = weekCalendarBuilder(context, state, weekCalendarStatuses[offset]);
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  weekCalendar,
                  const Divider(height: 1),
                ],
              );
            }),
          ],
        );
      },
      error: (error, _) => Text(error.toString()),
      loading: () => const Indicator(),
    );
  }
}
