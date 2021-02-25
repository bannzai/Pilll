import 'package:Pilll/components/molecules/app_card.dart';
import 'package:Pilll/domain/calendar/calculator.dart';
import 'package:Pilll/domain/calendar/calendar.dart';
import 'package:Pilll/domain/calendar/utility.dart';
import 'package:Pilll/domain/calendar/calendar_band_model.dart';
import 'package:Pilll/domain/calendar/calendar_help.dart';
import 'package:Pilll/domain/calendar/calendar_list_page.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/entity/setting.dart';
import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/store/pill_sheet.dart';
import 'package:Pilll/store/setting.dart';
import 'package:Pilll/components/atoms/buttons.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/util/datetime/day.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
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
    return AppCard(
      child: Column(
        children: <Widget>[
          _header(context),
          Calendar(
            calculator: Calculator(date),
            bandModels: buildBandModels(
                currentPillSheetState.latestPillSheet, settingState.entity, 0),
            horizontalPadding: 16,
          ),
          _more(context, settingState.entity, currentPillSheetState.entities),
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
      BuildContext context, Setting setting, List<PillSheetModel> pillSheets) {
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
                  final latestPillSheet = extractLatestPillSheet(pillSheets);
                  final previousBands = List.generate(6, (index) => index + 1)
                      .reversed
                      .map((number) {
                    CalendarListPageModel previous = CalendarListPageModel(
                        Calculator(DateTime(now.year, now.month - number, 1)),
                        []);
                    return previous;
                  });
                  final currentBands =
                      pillSheets.map((e) => CalendarListPageModel(
                            Calculator(now),
                            buildBandModels(e, setting, 0),
                          ));
                  List<CalendarBandModel> satisfyNextMonthDateRanges = [];
                  if (latestPillSheet != null) {
                    satisfyNextMonthDateRanges = List.generate(12, (index) {
                      return buildBandModels(latestPillSheet, setting, index);
                    }).expand((element) => element).toList();
                  }
                  final nextBands = List.generate(
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
                    ...previousBands,
                    ...currentBands,
                    ...nextBands,
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
