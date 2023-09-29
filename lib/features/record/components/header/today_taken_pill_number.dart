import 'package:flutter/cupertino.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/setting.codegen.dart';

class TodayTakenPillNumber extends StatelessWidget {
  final PillSheetGroup? pillSheetGroup;
  final VoidCallback onPressed;
  final Setting setting;

  const TodayTakenPillNumber({
    Key? key,
    required this.pillSheetGroup,
    required this.onPressed,
    required this.setting,
  }) : super(key: key);

  PillSheetAppearanceMode get _appearanceMode => setting.pillSheetAppearanceMode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_appearanceMode == PillSheetAppearanceMode.sequential)
            const Text(
              "💊 今日は服用",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.noshime,
              ),
            ),
          if (_appearanceMode != PillSheetAppearanceMode.sequential)
            const Text(
              "💊 今日飲むピル",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.noshime,
              ),
            ),
          _content(),
        ],
      ),
      onTap: () {
        analytics.logEvent(name: "tapped_record_page_today_pill");
        if (pillSheetGroup?.activePillSheet == null) {
          return;
        }
        onPressed();
      },
    );
  }

  Widget _content() {
    final pillSheetGroup = this.pillSheetGroup;
    final activePillSheet = this.pillSheetGroup?.activePillSheet;
    if (pillSheetGroup == null || activePillSheet == null || pillSheetGroup.isDeactived || activePillSheet.activeRestDuration != null) {
      return const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text("-",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: TextColor.noshime,
              )));
    }
    if (activePillSheet.inNotTakenDuration) {
      return Text(
        "${activePillSheet.pillSheetType.notTakenWord}${activePillSheet.todayPillNumber - activePillSheet.typeInfo.dosingPeriod}日目",
        style: const TextStyle(
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: TextColor.main,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: <Widget>[
        if (_appearanceMode == PillSheetAppearanceMode.number) ...[
          Text("${activePillSheet.todayPillNumber}",
              style: const TextStyle(
                fontFamily: FontFamily.number,
                fontWeight: FontWeight.w500,
                fontSize: 40,
                color: TextColor.main,
              )),
          const Text("番",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: TextColor.noshime,
              )),
        ],
        if (_appearanceMode == PillSheetAppearanceMode.date) ...[
          Text("${activePillSheet.todayPillNumber}",
              style: const TextStyle(
                fontFamily: FontFamily.number,
                fontWeight: FontWeight.w500,
                fontSize: 40,
                color: TextColor.main,
              )),
          const Text("番",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: TextColor.noshime,
              )),
        ],
        if (_appearanceMode == PillSheetAppearanceMode.sequential) ...[
          Text("${pillSheetGroup.sequentialTodayPillNumber}",
              style: const TextStyle(
                fontFamily: FontFamily.number,
                fontWeight: FontWeight.w500,
                fontSize: 40,
                color: TextColor.main,
              )),
          const Text("番",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: TextColor.noshime,
              )),
        ],
      ],
    );
  }
}
