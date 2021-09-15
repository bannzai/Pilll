import 'package:flutter/cupertino.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/components/header/today_taken_pill_number.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_page.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

abstract class RecordPageInformationHeaderConst {
  static final double height = 130;
}

class RecordPageInformationHeader extends StatelessWidget {
  final DateTime today;
  final PillSheetGroup? pillSheetGroup;
  final RecordPageStore store;
  const RecordPageInformationHeader({
    Key? key,
    required this.today,
    required this.pillSheetGroup,
    required this.store,
  }) : super(key: key);

  String _formattedToday() => DateTimeFormatter.monthAndDay(this.today);
  String _todayWeekday() => DateTimeFormatter.weekday(this.today);

  @override
  Widget build(BuildContext context) {
    final pillSheetGroup = this.pillSheetGroup;
    final activedPillSheet = pillSheetGroup?.activedPillSheet;

    return Container(
      height: RecordPageInformationHeaderConst.height,
      child: Column(
        children: <Widget>[
          SizedBox(height: 34),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _todayWidget(),
              SizedBox(width: 28),
              Container(
                height: 64,
                child: VerticalDivider(
                  width: 10,
                  color: PilllColors.divider,
                ),
              ),
              SizedBox(width: 28),
              TodayTakenPillNumber(
                  pillSheetGroup: pillSheetGroup,
                  onPressed: () {
                    analytics.logEvent(
                        name: "tapped_record_information_header");
                    if (activedPillSheet != null && pillSheetGroup != null) {
                      Navigator.of(context).push(
                        SettingTodayPillNumberPageRoute.route(
                          pillSheetGroup: pillSheetGroup,
                          activedPillSheet: activedPillSheet,
                        ),
                      );
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Center _todayWidget() {
    return Center(
      child: Text(
        "${_formattedToday()} (${_todayWeekday()})",
        style: FontType.xBigNumber.merge(TextColorStyle.gray),
      ),
    );
  }
}
