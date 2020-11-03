import 'package:Pilll/calendar/calculator.dart';
import 'package:Pilll/calendar/calendar.dart';
import 'package:Pilll/calendar/utility.dart';
import 'package:Pilll/calendar/calendar_band_model.dart';
import 'package:Pilll/calendar/calendar_help.dart';
import 'package:Pilll/calendar/calendar_list_page.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/entity/setting.dart';
import 'package:Pilll/store/pill_sheet.dart';
import 'package:Pilll/store/setting.dart';
import 'package:Pilll/components/atoms/buttons.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:Pilll/util/datetime/today.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/all.dart';

class CalendarCard extends HookWidget {
  final DateTime date;

  const CalendarCard({Key key, @required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPillSheetState = useProvider(pillSheetStoreProvider.state);
    final settingState = useProvider(settingStoreProvider.state);
    return Card(
      child: Column(
        children: <Widget>[
          _header(context),
          Calendar(
            calculator: Calculator(date),
            bandModels: [
              if (currentPillSheetState.entity != null) ...[
                menstruationDateRange(
                        currentPillSheetState.entity, settingState.entity, 0)
                    .map((range) =>
                        CalendarMenstruationBandModel(range.begin, range.end)),
                nextPillSheetDateRange(currentPillSheetState.entity, 0).map(
                    (range) =>
                        CalendarNextPillSheetBandModel(range.begin, range.end)),
              ]
            ],
          ),
          _more(context, settingState.entity, currentPillSheetState.entity),
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

  Widget _more(
      BuildContext context, Setting setting, PillSheetModel currentPillSheet) {
    var now = today();
    CalendarListPageModel previous = CalendarListPageModel(
        Calculator(DateTime(now.year, now.month - 1, 1)), []);
    CalendarListPageModel current = CalendarListPageModel(Calculator(now), [
      if (currentPillSheet != null) ...[
        menstruationDateRange(currentPillSheet, setting, 0).map((dateRange) =>
            CalendarMenstruationBandModel(dateRange.begin, dateRange.end)),
        nextPillSheetDateRange(currentPillSheet, 0).map((dateRange) =>
            CalendarNextPillSheetBandModel(dateRange.begin, dateRange.end))
      ]
    ]);
    CalendarListPageModel next = CalendarListPageModel(
        Calculator(DateTime(now.year, now.month + 1, 1)), [
      if (currentPillSheet != null) ...[
        menstruationDateRange(currentPillSheet, setting, 1).map((dateRange) =>
            CalendarMenstruationBandModel(dateRange.begin, dateRange.end)),
        nextPillSheetDateRange(currentPillSheet, 1).map((dateRange) =>
            CalendarNextPillSheetBandModel(dateRange.begin, dateRange.end))
      ]
    ]);
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SecondaryButton(
            text: "もっと見る",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return CalendarListPage(models: [
                      previous,
                      current,
                      next,
                    ]);
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
