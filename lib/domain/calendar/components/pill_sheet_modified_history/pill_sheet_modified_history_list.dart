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
        m.pillSheetModifiedHistories.add(history);
      } else {
        models.add(
          CalendarPillSheetModifiedHistoryListModel(
            dateTimeOfMonth: history.createdAt,
            pillSheetModifiedHistories: [history],
          ),
        );
      }
    });
    return models;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: models
          .map((model) {
            return [
              CalendarPillSheetModifiedHistoryMonthlyHeader(
                dateTimeOfMonth: model.dateTimeOfMonth,
              ),
              ...model.pillSheetModifiedHistories.map((history) {
                final actionType = history.enumActionType;
                if (actionType == null) {
                  return Container();
                }
                switch (actionType) {
                  case PillSheetModifiedActionType.createdPillSheet:
                    // TODO: Handle this case.
                    break;
                  case PillSheetModifiedActionType
                      .automaticallyRecordedLastTakenDate:
                    return PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction(
                      createdAt: history.createdAt,
                      pillSheetType: history.after.pillSheetType,
                      value: history.value.automaticallyRecordedLastTakenDate,
                    );
                  case PillSheetModifiedActionType.deletedPillSheet:
                    return PillSheetModifiedHistoryDeletedPillSheetAction(
                      createdAt: history.createdAt,
                      value: history.value.deletedPillSheet,
                    );
                  case PillSheetModifiedActionType.takenPill:
                    return PillSheetModifiedHistoryTakenPillAction(
                      createdAt: history.createdAt,
                      value: history.value.takenPill,
                      afterPillSheet: history.after,
                    );
                  case PillSheetModifiedActionType.revertTakenPill:
                    return PillSheetModifiedHistoryRevertTakenPillAction(
                      createdAt: history.createdAt,
                      value: history.value.revertTakenPill,
                    );
                  case PillSheetModifiedActionType.changedPillNumber:
                    return PillSheetModifiedHistoryChangedPillNumberAction(
                      createdAt: history.createdAt,
                      value: history.value.changedPillNumber,
                    );
                  case PillSheetModifiedActionType.endedPillSheet:
                    return PillSheetModifiedHistoryEndedPillSheetAction(
                      value: history.value.endedPillSheet,
                    );
                }
                return Container();
              }).toList()
            ];
          })
          .expand((element) => element)
          .toList(),
    );
  }
}
