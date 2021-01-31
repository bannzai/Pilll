import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/entity/pill_sheet_type.dart';
import 'package:Pilll/state/pill_sheet.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

class RecordTakenInformation extends StatelessWidget {
  final DateTime today;
  final PillSheetState state;
  PillSheetModel get pillSheetModel => state.entity;
  final VoidCallback onPressed;
  const RecordTakenInformation({
    Key key,
    @required this.today,
    @required this.state,
    @required this.onPressed,
  })  : assert(today != null),
        super(key: key);

  String _formattedToday() => DateTimeFormatter.monthAndDay(this.today);

  String _todayWeekday() => DateTimeFormatter.weekday(this.today);
  bool get pillSheetIsValid => pillSheetModel != null && !state.isInvalid;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
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
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "💊 今日飲むピル",
            style: FontType.assisting.merge(TextColorStyle.noshime),
          ),
          if (pillSheetIsValid) SizedBox(height: 8),
          if (!pillSheetIsValid) SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: <Widget>[
              if (pillSheetIsValid) ...[
                if (!pillSheetModel.inNotTakenDuration) ...[
                  Text("${pillSheetModel.todayPillNumber}",
                      style: FontType.xHugeNumber.merge(TextColorStyle.main)),
                  Text("番",
                      style:
                          FontType.assistingBold.merge(TextColorStyle.noshime)),
                ],
                if (pillSheetModel.inNotTakenDuration) ...[
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
