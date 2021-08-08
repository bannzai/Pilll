import 'package:flutter/material.dart';
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
