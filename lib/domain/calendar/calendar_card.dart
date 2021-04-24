import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/domain/calendar/calendar_weekday_line.dart';
import 'package:pilll/domain/calendar/monthly_calendar_state.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/domain/calendar/utility.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/domain/calendar/calendar_list_page.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarCardState {
  final DateTime date;
  final PillSheetModel? latestPillSheet;
  final Setting? setting;
  final List<Menstruation> menstruations;

  CalendarCardState({
    required this.date,
    required this.latestPillSheet,
    required this.setting,
    required this.menstruations,
  });

  String get dateTitle => DateTimeFormatter.yearAndMonth(date);

  List<CalendarBandModel> bands() {
    return buildBandModels(latestPillSheet, setting, menstruations, 1);
  }

  List<CalendarListPageModel> calendarListModels() {
    final bands = buildBandModels(latestPillSheet, setting, menstruations, 12);
    var now = today();
    final previouses =
        List.generate(6, (index) => index + 1).reversed.map((number) {
      CalendarListPageModel previous = CalendarListPageModel(
          CalendarTabState(DateTime(now.year, now.month - number, 1)), bands);
      return previous;
    });
    CalendarListPageModel current = CalendarListPageModel(
      CalendarTabState(now),
      bands,
    );
    List<CalendarBandModel> satisfyNextMonthDateRanges = [];
    if (latestPillSheet != null) {
      satisfyNextMonthDateRanges = bands;
    }
    final nextCalendars = List.generate(
      6,
      (index) {
        return CalendarListPageModel(
            CalendarTabState(DateTime(now.year, now.month + index + 1, 1)),
            [if (latestPillSheet != null) ...satisfyNextMonthDateRanges]);
      },
    );
    return [
      ...previouses,
      current,
      ...nextCalendars,
    ];
  }
}

class CalendarCard extends StatelessWidget {
  final CalendarCardState state;
  const CalendarCard({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: <Widget>[
          Calendar(
            calendarState: CalendarTabState(state.date),
            bandModels: state.bands(),
            onTap: (date, diaries) {
              analytics.logEvent(name: "did_select_day_tile_on_calendar_card");
              transitionToPostDiary(context, date, diaries);
            },
            horizontalPadding: 0,
          ),
        ],
      ),
    );
  }
}
