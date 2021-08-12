import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';

class TakenPillActionOList extends StatelessWidget {
  final TakenPillValue value;
  final PillSheet afterPillSheet;

  const TakenPillActionOList({
    Key? key,
    required this.value,
    required this.afterPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: List.generate(3, (index) {
      final inRestDuration = _inRestDuration(
          afterPillSheet, value.afterLastTakenPillNumber, index);
      if (index == 0) {
        return _centerWidget(!inRestDuration
            ? SvgPicture.asset(
                "images/dash_o.svg",
              )
            : SvgPicture.asset(
                "images/o.svg",
              ));
      } else {
        return _shiftWidget(
            !inRestDuration
                ? SvgPicture.asset("images/dash_half_o.svg")
                : SvgPicture.asset(
                    "images/half_o.svg",
                  ),
            index);
      }
    }).reversed.toList());
  }

  Widget _centerWidget(Widget picture) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        child: picture,
      ),
    );
  }

  Widget _shiftWidget(Widget picture, int index) {
    return Align(
      alignment: Alignment(0.6 * index, 0),
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
