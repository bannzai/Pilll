import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

abstract class RecordTakenInformationConst {
  static final double height = 130;
}

class RecordTakenInformation extends StatelessWidget {
  final DateTime today;
  final RecordPageState state;
  PillSheet? get pillSheetModel => state.pillSheetGroup?.activedPillSheet;
  final VoidCallback onPressed;
  const RecordTakenInformation({
    Key? key,
    required this.today,
    required this.state,
    required this.onPressed,
  }) : super(key: key);

  String _formattedToday() => DateTimeFormatter.monthAndDay(this.today);

  String _todayWeekday() => DateTimeFormatter.weekday(this.today);
  bool get pillSheetIsValid => pillSheetModel != null && !state.pillSheetGroupIsHidden;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: RecordTakenInformationConst.height,
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
              _takenWidget(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _takenWidget() {
    final pillSheetModel = this.pillSheetModel;
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "💊 今日飲むピル",
            style: FontType.assisting.merge(TextColorStyle.noshime),
          ),
          if (pillSheetIsValid) SizedBox(height: 4),
          if (!pillSheetIsValid) SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: <Widget>[
              if (pillSheetIsValid) ...[
                if (pillSheetModel != null &&
                    !pillSheetModel.inNotTakenDuration) ...[
                  Text("${pillSheetModel.todayPillNumber}",
                      style: FontType.xHugeNumber.merge(TextColorStyle.main)),
                  Text("番",
                      style:
                          FontType.assistingBold.merge(TextColorStyle.noshime)),
                ],
                if (pillSheetModel != null &&
                    pillSheetModel.inNotTakenDuration) ...[
                  Text(
                    "${pillSheetModel.pillSheetType.notTakenWord}${pillSheetModel.todayPillNumber - pillSheetModel.typeInfo.dosingPeriod}日目",
                    style: FontType.assistingBold.merge(TextColorStyle.main),
                  ),
                ],
              ],
              if (!pillSheetIsValid) ...[
                Text("-",
                    style: FontType.assisting.merge(TextColorStyle.noshime)),
              ],
            ],
          )
        ],
      ),
      onTap: () {
        if (!pillSheetIsValid) {
          return;
        }
        this.onPressed();
      },
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
