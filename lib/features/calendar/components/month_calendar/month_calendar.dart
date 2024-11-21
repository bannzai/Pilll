import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/organisms/calendar/week/utility.dart';
import 'package:pilll/features/calendar/components/const.dart';
import 'package:pilll/utils/datetime/date_range.dart';
import 'package:pilll/features/record/weekday_badge.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/material.dart';
import 'package:pilll/provider/diary.dart';
import 'package:pilll/provider/schedule.dart';

class MonthCalendar extends HookConsumerWidget {
  final DateTime dateForMonth;
  final Widget Function(BuildContext, List<Diary>, List<Schedule>, DateRange) weekCalendarBuilder;

  const MonthCalendar({
    super.key,
    required this.dateForMonth,
    required this.weekCalendarBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      // Prefetch
      ref.read(diariesForMonthProvider(DateTime(dateForMonth.year, dateForMonth.month + 1, 1)));
      ref.read(diariesForMonthProvider(DateTime(dateForMonth.year, dateForMonth.month - 1, 1)));
      ref.read(schedulesForMonthProvider(DateTime(dateForMonth.year, dateForMonth.month + 1, 1)));
      ref.read(schedulesForMonthProvider(DateTime(dateForMonth.year, dateForMonth.month - 1, 1)));
      return null;
    }, [dateForMonth]);
    return AsyncValueGroup.group2(
      ref.watch(diariesForMonthProvider(dateForMonth)),
      ref.watch(schedulesForMonthProvider(dateForMonth)),
    ).when(
      data: (data) {
        final diaries = data.$1;
        final schedules = data.$2;
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
                ),
              ),
            ),
            const Divider(height: 1),
            ...List.generate(CalendarConstants.maxLineCount, (offset) {
              if (weeks.length <= offset) {
                return const Column(
                  children: [
                    SizedBox(height: CalendarConstants.tileHeight),
                    Divider(height: 1),
                  ],
                );
              }

              final weekCalendar = weekCalendarBuilder(context, diaries, schedules, weeks[offset]);
              return Column(
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

  WeekCalendarDateRangeCalculator get _calculator => WeekCalendarDateRangeCalculator(dateForMonth);
  List<DateRange> get _weeks =>
      List.generate(_calculator.weeklineCount(), (index) => index + 1).map((line) => _calculator.dateRangeOfLine(line)).toList();
}
