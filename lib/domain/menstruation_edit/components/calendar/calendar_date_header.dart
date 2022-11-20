import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

abstract class CalendarDateHeaderConst {
  static double headerHeight = 64;
}

class CalendarDateHeader extends StatelessWidget {
  final DateTime date;
  const CalendarDateHeader({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: CalendarDateHeaderConst.headerHeight),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Text(
            DateTimeFormatter.yearAndMonth(date),
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontFamily: FontFamily.number,
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: TextColor.noshime,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
