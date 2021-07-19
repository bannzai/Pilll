import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/shadow_container.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/domain/calendar/weekly/weekly_calendar.dart';
import 'package:pilll/domain/calendar/monthly_calendar_state.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarCardState {
  final DateTime date;
  final PillSheet? latestPillSheet;
  final Setting? setting;
  final List<Diary> diaries;
  final List<Menstruation> menstruations;
  final List<CalendarBandModel> bands;

  CalendarCardState({
    required this.date,
    required this.latestPillSheet,
    required this.setting,
    required this.diaries,
    required this.menstruations,
    required this.bands,
  });

  String get dateTitle => DateTimeFormatter.yearAndMonth(date);
}

class CalendarCard extends StatelessWidget {
  final CalendarCardState state;
  const CalendarCard({
    Key? key,
    required this.state,
  }) : super(key: key);

  CalendarTabState get _calendarTabState => CalendarTabState(state.date);

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(child: MonthlyCalendarLayout(
      weeklyCalendarBuilder: (context, offset) {
        final line = offset + 1;
        if (_calendarTabState.weeklineCount() <
                CalendarConstants.constantLineCount &&
            line == CalendarConstants.constantLineCount) {
          return null;
        }
        final diaries = state.diaries;
        return CalendarWeekdayLine(
          diaries: diaries,
          calendarState: _calendarTabState.weeklyCalendarState(line),
          bandModels: state.bands,
          horizontalPadding: 0,
          onTap: (weeklyCalendarState, date) {
            analytics.logEvent(name: "did_select_day_tile_on_calendar_card");
            transitionToPostDiary(context, date, diaries);
          },
        );
      },
    ));
  }
}
