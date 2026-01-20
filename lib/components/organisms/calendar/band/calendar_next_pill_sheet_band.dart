import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/diagonal_striped_line.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band.dart';
import 'package:pilll/features/localizations/l.dart';

class CalendarNextPillSheetBand extends StatelessWidget {
  const CalendarNextPillSheetBand({
    super.key,
    required this.begin,
    required this.end,
    required this.isLineBreak,
    required this.width,
  });

  final DateTime begin;
  final DateTime end;
  final bool isLineBreak;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CalendarBandConst.height,
      child: Stack(
        children: [
          CustomPaint(
            painter: DiagonalStripedLine(
              color: AppColors.duration,
              isNecessaryBorder: false,
            ),
            size: Size(width, CalendarBandConst.height),
          ),
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              isLineBreak ? '' : L.newPillSheetStart,
              style: const TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w600,
                fontSize: 10,
                color: TextColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
