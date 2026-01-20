import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class TakenPillActionOList extends StatelessWidget {
  final PillSheetGroup beforePillSheetGroup;
  final PillSheetGroup afterPillSheetGroup;

  const TakenPillActionOList({
    super.key,
    required this.beforePillSheetGroup,
    required this.afterPillSheetGroup,
  });

  @override
  Widget build(BuildContext context) {
    final beforePillSheet =
        beforePillSheetGroup.lastTakenPillSheetOrFirstPillSheet;
    final afterPillSheet =
        afterPillSheetGroup.lastTakenPillSheetOrFirstPillSheet;
    final int takenPillCount;
    if (beforePillSheet.groupIndex == afterPillSheet.groupIndex) {
      takenPillCount = max(
        afterPillSheet.lastTakenOrZeroPillNumber -
            beforePillSheet.lastTakenOrZeroPillNumber,
        1,
      );
    } else {
      // beforePillSheet.groupIndex != afterPillSheet.groupIndex
      // groupIndexが異なる場合は、beforePillSheetの合計数 - 最後に飲んだ番号を beforePilSheetの服用した数。それにafterPillSheetで記録した番号を足すことで服用したピルの数を計算する
      // 厳密にはbeforePillSheetが最後のピルシートで、服用記録対象がafterPillSheetの最初のピルシートの場合に合致する条件だが、それ以外のケースがレアケースのため条件式を省く
      takenPillCount =
          (beforePillSheet.pillSheetType.totalCount -
              beforePillSheet.lastTakenOrZeroPillNumber) +
          afterPillSheet.lastTakenOrZeroPillNumber;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(min(takenPillCount, 4), (index) {
        final afterLastTakenPillNumber =
            afterPillSheet.lastTakenOrZeroPillNumber;
        final inRestDuration = _inRestDuration(
          afterPillSheet,
          afterLastTakenPillNumber,
          index,
        );
        if (index == 0) {
          return inRestDuration
              ? SvgPicture.asset('images/dash_o.svg')
              : SvgPicture.asset('images/o.svg');
        } else if (index < 3) {
          return _halfOWidgetWithTransform(
            inRestDuration
                ? SvgPicture.asset('images/dash_half_o.svg')
                : SvgPicture.asset('images/half_o.svg'),
            index,
          );
        } else {
          return _dotsWidgetWithTransform(SvgPicture.asset('images/dots.svg'));
        }
      }).toList(),
    );
  }

  Widget _halfOWidgetWithTransform(Widget picture, int index) {
    return Container(
      transform: Matrix4.translationValues(-3.0 * index, 0, 0),
      child: Container(child: picture),
    );
  }

  Widget _dotsWidgetWithTransform(Widget picture) {
    return Container(
      transform: Matrix4.translationValues(-1.0 * 3, 0, 0),
      child: Container(child: picture),
    );
  }

  bool _inRestDuration(
    PillSheet afterPillSheet,
    int afterLastTakenPillNumber,
    int index,
  ) {
    final pillNumber = afterLastTakenPillNumber - index;
    return afterPillSheet.pillSheetType.dosingPeriod < pillNumber;
  }
}
