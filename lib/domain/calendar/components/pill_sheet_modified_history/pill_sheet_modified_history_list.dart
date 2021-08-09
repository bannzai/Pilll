import 'package:flutter/material.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_automatically_recorded_last_taken_date_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_changed_pill_number_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_deleted_pill_sheet_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_ended_pill_sheet_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_monthly_header.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_revert_taken_pill_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_pill_action.dart';
import 'package:pilll/entity/pill_sheet_modified_history.dart';
import 'package:pilll/util/datetime/date_compare.dart';

class CalendarPillSheetModifiedHistoryListModel {
  final DateTime dateTimeOfMonth;
  final List<PillSheetModifiedHistory> pillSheetModifiedHistories;
  CalendarPillSheetModifiedHistoryListModel({
    required this.dateTimeOfMonth,
    required this.pillSheetModifiedHistories,
  });
}

class CalendarPillSheetModifiedHistoryList extends StatelessWidget {
  final List<PillSheetModifiedHistory> pillSheetModifiedHistories;

  const CalendarPillSheetModifiedHistoryList(
      {Key? key, required this.pillSheetModifiedHistories})
      : super(key: key);

  List<CalendarPillSheetModifiedHistoryListModel> get models {
    final List<CalendarPillSheetModifiedHistoryListModel> models = [];
    pillSheetModifiedHistories.forEach((history) {
      CalendarPillSheetModifiedHistoryListModel? model;

      models.forEach((m) {
        if (isSameMonth(m.dateTimeOfMonth, history.createdAt)) {
          model = m;
          return;
        }
      });

      final m = model;
      if (m != null) {
        models.add(m);
      } else {
        models.add(CalendarPillSheetModifiedHistoryListModel(
            dateTimeOfMonth: history.createdAt,
            pillSheetModifiedHistories: pillSheetModifiedHistories));
      }
    });
    return models;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: models
          .map((model) {
            return [
              CalendarPillSheetModifiedHistoryMonthlyHeader(
                dateTimeOfMonth: model.dateTimeOfMonth,
              ),
              ...model.pillSheetModifiedHistories
                  .map((pillSheetModifiedHistory) {
                final actionType = pillSheetModifiedHistory.enumActionType;
                if (actionType == null) {
                  return Container();
                }
                switch (actionType) {
                  case PillSheetModifiedActionType.createdPillSheet:
                    // TODO: Handle this case.
                    break;
                  case PillSheetModifiedActionType
                      .automaticallyRecordedLastTakenDate:
                    return PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction();
                  case PillSheetModifiedActionType.deletedPillSheet:
                    return PillSheetModifiedHistoryDeletedPillSheetAction();
                  case PillSheetModifiedActionType.takenPill:
                    return PillSheetModifiedHistoryRevertTakenPillAction();
                  case PillSheetModifiedActionType.revertTakenPill:
                    return PillSheetModifiedHistoryRevertTakenPillAction();
                  case PillSheetModifiedActionType.changedPillNumber:
                    return PillSheetModifiedHistoryChangedPillNumberAction();
                  case PillSheetModifiedActionType.endedPillSheet:
                    return PillSheetModifiedHistoryEndedPillSheetAction();
                }
                return Container();
              }).toList()
            ];
          })
          .expand((element) => element)
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
