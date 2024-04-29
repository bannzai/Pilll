import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';

class TakenPillActionOList extends StatelessWidget {
  final TakenPillValue value;
  final PillSheet beforePillSheet;
  final PillSheet afterPillSheet;

  const TakenPillActionOList({
    super.key,
    required this.value,
    required this.beforePillSheet,
    required this.afterPillSheet,
  });

  @override
  Widget build(BuildContext context) {
    if (beforePillSheet.groupIndex != afterPillSheet.groupIndex) {
      return SvgPicture.asset("images/dots.svg");
    }
    final count = max(
        value.afterLastTakenPillNumber - (value.beforeLastTakenPillNumber), 1);
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(min(count, 4), (index) {
          final inRestDuration = _inRestDuration(
              afterPillSheet, value.afterLastTakenPillNumber, index);
          if (index == 0) {
            return inRestDuration
                ? SvgPicture.asset("images/dash_o.svg")
                : SvgPicture.asset("images/o.svg");
          } else if (index < 3) {
            return _halfOWidgetWithTransform(
                inRestDuration
                    ? SvgPicture.asset("images/dash_half_o.svg")
                    : SvgPicture.asset("images/half_o.svg"),
                index);
          } else {
            return _dotsWidgetWithTransform(
                SvgPicture.asset("images/dots.svg"));
          }
        }).toList());
  }

  Widget _halfOWidgetWithTransform(Widget picture, int index) {
    return Container(
      transform: Matrix4.translationValues(-3.0 * index, 0, 0),
      child: Container(
        child: picture,
      ),
    );
  }

  Widget _dotsWidgetWithTransform(Widget picture) {
    return Container(
      transform: Matrix4.translationValues(-1.0 * 3, 0, 0),
      child: Container(
        child: picture,
      ),
    );
  }

  bool _inRestDuration(
      PillSheet afterPillSheet, int afterLastTakenPillNumber, int index) {
    final pillNumber = afterLastTakenPillNumber - index;
    return afterPillSheet.pillSheetType.dosingPeriod < pillNumber;
  }
}
