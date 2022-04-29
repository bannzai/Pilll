import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/diagonal_striped_line.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band.dart';

// TODO: When alignemnt band, use with CalendarBandConst.height
class CalendarNextPillSheetBand extends StatelessWidget {
  const CalendarNextPillSheetBand({
    Key? key,
    required this.begin,
    required this.end,
    required this.isLineBreaked,
    required this.width,
  }) : super(key: key);

  final DateTime begin;
  final DateTime end;
  final bool isLineBreaked;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: CalendarBandConst.height,
      child: Stack(
        children: [
          CustomPaint(
            painter: DiagonalStripedLine(
                color: PilllColors.duration, isNecessaryBorder: false),
            size: Size(width, CalendarBandConst.height),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text("新しいシート開始 ▶︎",
                style: FontType.sSmallTitle.merge(TextColorStyle.white)),
          ),
        ],
      ),
    );
  }
}
