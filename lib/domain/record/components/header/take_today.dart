import 'package:flutter/cupertino.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter/material.dart';

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
