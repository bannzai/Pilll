import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/weekday.dart';

class Day extends StatelessWidget {
  final DateTime estimatedEventCausingDate;

  const Day({Key? key, required this.estimatedEventCausingDate})
      : super(key: key);

  int get _day => estimatedEventCausingDate.day;
  Weekday get _weekday =>
      WeekdayFunctions.weekdayFromDate(estimatedEventCausingDate);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 28,
          child: Text(
            "$_day",
            style: const TextStyle(
              color: TextColor.main,
              fontFamily: FontFamily.number,
              fontSize: 23,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "(${_weekday.weekdayString()})",
          style: const TextStyle(
            color: TextColor.main,
            fontFamily: FontFamily.japanese,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
