import 'package:flutter/material.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_automatically_recorded_last_taken_date_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_changed_pill_number_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_deleted_pill_sheet_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_ended_pill_sheet_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_monthly_header.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_revert_taken_pill_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_pill_action.dart';
import 'package:pilll/entity/pill_sheet_modified_history.dart';
import 'package:pilll/util/datetime/day.dart';

class CalendarPillSheetModifiedHistoryList extends StatelessWidget {
  final List<PillSheetModifiedHistory> pillSheetModifiedHistories;

  const CalendarPillSheetModifiedHistoryList(
      {Key? key, required this.pillSheetModifiedHistories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: pillSheetModifiedHistories.map((pillSheetModifiedHistory) {
        final actionType = pillSheetModifiedHistory.enumActionType;
        if (actionType == null) {
          return Container();
        }
        switch (actionType) {
          case PillSheetModifiedActionType.createdPillSheet:
            // TODO: Handle this case.
            break;
          case PillSheetModifiedActionType.automaticallyRecordedLastTakenDate:
            // TODO: Handle this case.
            break;
          case PillSheetModifiedActionType.deletedPillSheet:
            // TODO: Handle this case.
            break;
          case PillSheetModifiedActionType.takenPill:
            // TODO: Handle this case.
            break;
          case PillSheetModifiedActionType.revertTakenPill:
            // TODO: Handle this case.
            break;
          case PillSheetModifiedActionType.changedPillNumber:
            // TODO: Handle this case.
            break;
          case PillSheetModifiedActionType.endedPillSheet:
            // TODO: Handle this case.
            break;
        }
        return Container();
      })
          // .expand((element) => element)
          .toList(),
//        CalendarPillSheetModifiedHistoryMonthlyHeader(
//          dateTimeOfMonth: today(),
//        ),
//        CalendarPillSheetModifiedHistoryTakenPillActionElement(),
//        PillSheetModifiedHistoryEndedPillSheetAction(),
//        PillSheetModifiedHistoryDeletedPillSheetAction(),
//        PillSheetModifiedHistoryChangedPillNumberAction(),
//        PillSheetModifiedHistoryRevertTakenPillAction(),
//        PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction(),
//      ],
    );
  }
}
