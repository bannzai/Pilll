import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

class PillSheetModifiedHistoryMonthlyHeader extends StatelessWidget {
  final DateTime dateTimeOfMonth;

  const PillSheetModifiedHistoryMonthlyHeader(
      {Key? key, required this.dateTimeOfMonth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      DateTimeFormatter.jaMonth(dateTimeOfMonth),
      style: const TextStyle(
        color: TextColor.main,
        fontFamily: FontFamily.japanese,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
