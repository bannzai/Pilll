import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

import 'calendar_band_model.dart';

abstract class CalendarBandConst {
  static const double height = 13;
}

class CalendarBand extends StatelessWidget {
  const CalendarBand({
    Key? key,
    required this.model,
    required this.isLineBreaked,
  }) : super(key: key);

  final CalendarBandModel model;
  final bool isLineBreaked;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CalendarBandConst.height,
      decoration: BoxDecoration(color: model.color),
      child: Container(
        padding: EdgeInsets.only(left: 10),
        child: Text(isLineBreaked ? "" : model.label,
            style: FontType.sSmallTitle.merge(TextColorStyle.white)),
      ),
    );
  }
}
