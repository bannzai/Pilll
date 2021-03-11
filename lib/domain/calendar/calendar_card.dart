import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/domain/calendar/calculator.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/domain/calendar/utility.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/domain/calendar/calendar_help.dart';
import 'package:pilll/domain/calendar/calendar_list_page.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/store/pill_sheet.dart';
import 'package:pilll/store/setting.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CalendarCard extends HookWidget {
  final DateTime date;

  const CalendarCard({Key key, @required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentPillSheetState = useProvider(pillSheetStoreProvider.state);
    final settingState = useProvider(settingStoreProvider.state);
    return AppCard(
      child: Column(
        children: <Widget>[
          _header(context),
          Calendar(
            calculator: Calculator(date),
            bandModels: buildBandModels(
                currentPillSheetState.entity, settingState.entity, 0),
            horizontalPadding: 16,
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
      BuildContext context, Setting setting, PillSheetModel latestPillSheet) {
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
                        Calculator(DateTime(now.year, now.month - number, 1)),
                        []);
                    return previous;
                  });
                  CalendarListPageModel current = CalendarListPageModel(
                    Calculator(now),
                    buildBandModels(latestPillSheet, setting, 0),
                  );
                  List<CalendarBandModel> satisfyNextMonthDateRanges = [];
                  if (latestPillSheet != null) {
                    satisfyNextMonthDateRanges = List.generate(12, (index) {
                      return buildBandModels(latestPillSheet, setting, index);
                    }).expand((element) => element).toList();
                  }
                  final nextCalendars = List.generate(
                    6,
                    (index) {
                      return CalendarListPageModel(
                          Calculator(
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
