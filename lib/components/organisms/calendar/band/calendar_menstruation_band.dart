import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/molecules/diagonal_striped_line.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band.dart';
import 'package:pilll/entity/menstruation.codegen.dart';

class CalendarMenstruationBand extends StatelessWidget {
  const CalendarMenstruationBand({
    Key? key,
    required this.menstruation,
    required this.width,
    required this.onTap,
  }) : super(key: key);

  final Menstruation menstruation;
  final double width;
  final Function(Menstruation) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(menstruation),
      child: SizedBox(
        height: CalendarBandConst.height,
        child: CustomPaint(
          painter: DiagonalStripedLine(
            color: PilllColors.menstruation,
            isNecessaryBorder: false,
          ),
          size: Size(width, CalendarBandConst.height),
        ),
      ),
    );
  }
}
