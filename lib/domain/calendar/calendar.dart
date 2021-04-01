import 'package:pilll/domain/calendar/monthly_calendar_state.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/calendar/calendar_weekday_line.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/service/diary.dart';
import 'package:pilll/store/diaries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class CalendarConstants {
  static final double tileHeight = 60;
}

final AutoDisposeFutureProviderFamily<List<Diary>, DateTime>?
    calendarDiariesProvider = FutureProvider.autoDispose
        .family<List<Diary>, DateTime>((ref, DateTime dateTimeOfMonth) {
  final state = ref.watch(diariesStoreProvider.state);
  if (state.entities.isNotEmpty) {
    return Future.value(state.entities);
  }
  final diaries = ref.watch(diaryServiceProvider);
  return diaries.fetchListForMonth(dateTimeOfMonth);
});

class Calendar extends HookWidget {
  final MonthlyCalendarState calendarState;
  final List<CalendarBandModel> bandModels;
  final double horizontalPadding;

  const Calendar({
    Key? key,
    required this.calendarState,
    required this.bandModels,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final futureCalendarDiaries =
        useProvider(calendarDiariesProvider!(calendarState.date));
    return futureCalendarDiaries.when(
      data: (value) {
        return _body(context, value);
      },
      loading: () => Indicator(),
      error: (error, trace) => Indicator(),
    );
  }

  DateTime date() => calendarState.date;
  double height() =>
      calendarState.lineCount().toDouble() * CalendarConstants.tileHeight;

  Column _body(BuildContext context, List<Diary> diaries) {
    return Column(
      children: <Widget>[
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
        Divider(height: 1),
        ...List.generate(calendarState.lineCount(), (_line) {
          final line = _line + 1;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CalendarWeekdayLine(
                context: context,
                diaries: diaries,
                calendarState: calendarState.weeklyCalendarState(line),
                bandModels: bandModels,
                horizontalPadding: horizontalPadding,
              ),
              Divider(height: 1),
            ],
          );
        }),
      ],
    );
  }
}
