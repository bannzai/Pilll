import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/diagonal_striped_line.dart';

import 'calendar_band_model.dart';

abstract class CalendarBandConst {
  static const double height = 13;
}

class CalendarBand extends StatelessWidget {
  const CalendarBand({
    Key? key,
    required this.model,
    required this.isLineBreaked,
    required this.width,
  }) : super(key: key);

  final CalendarBandModel model;
  final bool isLineBreaked;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CalendarBandConst.height,
      child: Stack(
        children: [
          CustomPaint(
            painter: DiagonalStripedLine(model.color),
            size: Size(width, CalendarBandConst.height),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(isLineBreaked ? "" : model.label,
                style: FontType.sSmallTitle.merge(TextColorStyle.white)),
          ),
        ],
      ),
    );
  }
}
