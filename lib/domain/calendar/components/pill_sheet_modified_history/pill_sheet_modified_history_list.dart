import 'package:flutter/material.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class CalendarPillSheetModifiedHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [],
    );
  }
}

class CalendarPillSheetModifiedHistoryMonth extends StatelessWidget {
  final DateTime dateTimeOfMonth;

  const CalendarPillSheetModifiedHistoryMonth(
      {Key? key, required this.dateTimeOfMonth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(DateTimeFormatter.jaMonth(dateTimeOfMonth));
  }
}
