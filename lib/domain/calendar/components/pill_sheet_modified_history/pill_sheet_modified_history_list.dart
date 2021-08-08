import 'package:flutter/material.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/monthly_header.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_taken_pill_action.dart';
import 'package:pilll/util/datetime/day.dart';

class CalendarPillSheetModifiedHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalendarPillSheetModifiedHistoryMonthHeader(
          dateTimeOfMonth: today(),
        ),
        CalendarPillSheetModifiedHistoryTakenPillActionElement(),
        CalendarPillSheetModifiedHistoryTakenPillActionElement(),
        CalendarPillSheetModifiedHistoryTakenPillActionElement(),
      ],
    );
  }
}
