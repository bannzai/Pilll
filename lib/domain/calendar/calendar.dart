import 'package:pilll/domain/calendar/monthly_calendar_state.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/domain/calendar/calendar_weekday_line.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/store/diaries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class CalendarConstants {
  static final double tileHeight = 66;
}

class Calendar extends HookWidget {
  final MonthlyCalendarState calendarState;
  final List<CalendarBandModel> bandModels;
  final Function(DateTime, List<Diary>) onTap;
  final double horizontalPadding;

  const Calendar({
    Key? key,
    required this.calendarState,
    required this.bandModels,
    required this.onTap,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(
        monthlyDiariesStoreProvider(calendarState.dateForMonth).state);
    return _body(context, state.entities);
  }

  DateTime date() => calendarState.dateForMonth;
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
                  diaries: diaries,
                  calendarState: calendarState.weeklyCalendarState(line),
                  bandModels: bandModels,
                  horizontalPadding: horizontalPadding,
                  onTap: (weeklyCalendarState, date) => onTap(date, diaries)),
              Divider(height: 1),
            ],
          );
        }),
      ],
    );
  }
}
