import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

abstract class RecordTakenInformationConst {
  static final double height = 130;
}

class RecordTakenInformation extends StatelessWidget {
  final DateTime today;
  final PillSheetGroup? pillSheetGroup;
  final VoidCallback onPressed;
  const RecordTakenInformation({
    Key? key,
    required this.today,
    required this.pillSheetGroup,
    required this.onPressed,
  }) : super(key: key);

  String _formattedToday() => DateTimeFormatter.monthAndDay(this.today);
  String _todayWeekday() => DateTimeFormatter.weekday(this.today);

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
              TakeToday(pillSheetGroup: pillSheetGroup, onPressed: onPressed),
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

class TakeToday extends StatelessWidget {
  final PillSheetGroup? pillSheetGroup;
  final VoidCallback onPressed;

  const TakeToday({
    Key? key,
    required this.pillSheetGroup,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "💊 今日飲むピル",
            style: FontType.assisting.merge(TextColorStyle.noshime),
          ),
          _content(),
        ],
      ),
      onTap: () {
        if (pillSheetGroup?.activedPillSheet == null) {
          return;
        }
        this.onPressed();
      },
    );
  }

  Widget _content() {
    final pillSheetGroup = this.pillSheetGroup;
    final pillSheet = this.pillSheetGroup?.activedPillSheet;
    if (pillSheetGroup == null || pillSheet == null || pillSheet.isInvalid) {
      return Text("-", style: FontType.assisting.merge(TextColorStyle.noshime));
    }
    if (pillSheet.inNotTakenDuration) {
      return Text(
        "${pillSheet.pillSheetType.notTakenWord}${pillSheet.todayPillNumber - pillSheet.typeInfo.dosingPeriod}日目",
        style: FontType.assistingBold.merge(TextColorStyle.main),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: <Widget>[
        Text("${pillSheetGroup.serializedTodayPillNumber}",
            style: FontType.xHugeNumber.merge(TextColorStyle.main)),
        Text("番", style: FontType.assistingBold.merge(TextColorStyle.noshime)),
      ],
    );
  }
}
