import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';

final double _oWidth = 17;
final double _halfOWidth = 13;

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
    // final count =
    // value.afterLastTakenPillNumber - (value.beforeLastTakenPillNumber ?? 1);
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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
          }).toList()),
    );
  }

  Widget _centerWidget(Widget picture) {
    return picture;
    return Align(
      alignment: Alignment.center,
      child: Container(
        child: picture,
      ),
    );
  }

  Widget _shiftWidget(Widget picture, int index) {
    return picture;
    final double x = (_oWidth / 2) * (_halfOWidth / _oWidth * index);
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
