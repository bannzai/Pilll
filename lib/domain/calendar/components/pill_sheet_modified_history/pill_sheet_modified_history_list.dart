import 'package:flutter/material.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_automatically_recorded_last_taken_date_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_monthly_header.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_pill_action.dart';
import 'package:pilll/util/datetime/day.dart';

class CalendarPillSheetModifiedHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalendarPillSheetModifiedHistoryMonthlyHeader(
          dateTimeOfMonth: today(),
        ),
        CalendarPillSheetModifiedHistoryTakenPillActionElement(),
        CalendarPillSheetModifiedHistoryTakenPillActionElement(),
        CalendarPillSheetModifiedHistoryTakenPillActionElement(),
        PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction(),
      ],
    );
  }
}
