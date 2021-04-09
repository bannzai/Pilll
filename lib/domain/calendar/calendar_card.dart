import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/domain/calendar/calendar_weekday_line.dart';
import 'package:pilll/domain/calendar/monthly_calendar_state.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/domain/calendar/utility.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/domain/calendar/calendar_help.dart';
import 'package:pilll/domain/calendar/calendar_list_page.dart';
import 'package:pilll/entity/menstruation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CalendarCard extends StatelessWidget {
  final DateTime date;
  final PillSheetModel? latestPillSheet;
  final Setting setting;
  final List<Menstruation> menstruations;

  const CalendarCard({
    Key? key,
    required this.date,
    required this.latestPillSheet,
    required this.setting,
    required this.menstruations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: <Widget>[
          _header(context),
          Calendar(
            calendarState: CalendarTabState(date),
            bandModels:
                buildBandModels(latestPillSheet, setting, menstruations, 1),
            onTap: (date, diaries) {
              analytics.logEvent(name: "did_select_day_tile_on_calendar_card");
              transitionToPostDiary(context, date, diaries);
            },
            horizontalPadding: 16,
          ),
          _more(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 64),
      child: Row(
        children: [
          SizedBox(width: 16),
          Text(
            DateTimeFormatter.yearAndMonth(date),
            textAlign: TextAlign.left,
            style: FontType.cardHeader.merge(TextColorStyle.noshime),
          ),
          Spacer(),
          IconButton(
            icon: SvgPicture.asset("images/help.svg"),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return CalendarHelpPage();
                  });
            },
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget _more(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SecondaryButton(
            text: "もっと見る",
            onPressed: () {
              Navigator.of(context).push(
                () {
                  var now = today();
                  final previouses = List.generate(6, (index) => index + 1)
                      .reversed
                      .map((number) {
                    CalendarListPageModel previous = CalendarListPageModel(
                        CalendarTabState(
                            DateTime(now.year, now.month - number, 1)),
                        []);
                    return previous;
                  });
                  CalendarListPageModel current = CalendarListPageModel(
                    CalendarTabState(now),
                    buildBandModels(latestPillSheet, setting, menstruations, 1),
                  );
                  List<CalendarBandModel> satisfyNextMonthDateRanges = [];
                  if (latestPillSheet != null) {
                    satisfyNextMonthDateRanges = buildBandModels(
                        latestPillSheet, setting, menstruations, 12);
                  }
                  final nextCalendars = List.generate(
                    6,
                    (index) {
                      return CalendarListPageModel(
                          CalendarTabState(
                              DateTime(now.year, now.month + index + 1, 1)),
                          [
                            if (latestPillSheet != null)
                              ...satisfyNextMonthDateRanges
                          ]);
                    },
                  );
                  return CalendarListPageRoute.route([
                    ...previouses,
                    current,
                    ...nextCalendars,
                  ]);
                }(),
              );
            },
          )
        ],
      ),
    );
  }
}
