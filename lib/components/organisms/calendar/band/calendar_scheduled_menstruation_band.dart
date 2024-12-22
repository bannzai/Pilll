import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/diagonal_striped_line.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band.dart';

class CalendarScheduledMenstruationBand extends StatelessWidget {
  const CalendarScheduledMenstruationBand({
    super.key,
    required this.begin,
    required this.end,
    required this.width,
  });

  final DateTime begin;
  final DateTime end;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CalendarBandConst.height,
      child: CustomPaint(
        painter: DiagonalStripedLine(
          color: AppColors.menstruation.withOpacity(0.6),
          isNecessaryBorder: true,
        ),
        size: Size(width, CalendarBandConst.height),
      ),
    );
  }
}
