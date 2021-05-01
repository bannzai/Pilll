import 'package:pilll/domain/calendar/monthly_calendar_state.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/domain/calendar/calendar_weekday_line.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

abstract class CalendarConstants {
  static final double tileHeight = 66;
}

class Calendar extends HookWidget {
  final MonthlyCalendarState calendarState;
  final List<CalendarBandModel> bandModels;
  final List<Diary> diaries;
  final Function(DateTime, List<Diary>) onTap;
  final double horizontalPadding;

  const Calendar({
    Key? key,
    required this.calendarState,
    required this.bandModels,
    required this.diaries,
    required this.onTap,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarBody(
        diaries: diaries,
        calendarState: calendarState,
        bandModels: bandModels,
        onTap: onTap,
        horizontalPadding: horizontalPadding);
  }

  DateTime date() => calendarState.dateForMonth;
  double height() =>
      calendarState.weeklineCount().toDouble() * CalendarConstants.tileHeight;
}

class CalendarBody extends StatelessWidget {
  final List<Diary> diaries;
  final MonthlyCalendarState calendarState;
  final List<CalendarBandModel> bandModels;
  final Function(DateTime, List<Diary>) onTap;
  final double horizontalPadding;

  const CalendarBody({
    Key? key,
    required this.diaries,
    required this.calendarState,
    required this.bandModels,
    required this.onTap,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        ...List.generate(calendarState.weeklineCount(), (_line) {
          final line = _line + 1;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CalendarWeekdayLine(
                diaries: diaries,
                calendarState: calendarState.weeklyCalendarState(line),
                bandModels: bandModels,
                horizontalPadding: horizontalPadding,
                onTap: (weeklyCalendarState, date) => onTap(date, diaries),
              ),
              Divider(height: 1),
            ],
          );
        }),
      ],
    );
  }
}
