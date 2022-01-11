import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_automatically_recorded_last_taken_date_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_began_rest_duration.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_changed_pill_number_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_created_pill_sheet_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_deleted_pill_sheet_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_ended_rest_duration.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_ended_pill_sheet_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_monthly_header.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_revert_taken_pill_action.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_taken_pill_action.dart';
import 'package:pilll/entity/pill_sheet_modified_history.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';
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
  final EdgeInsets? padding;
  final ScrollPhysics scrollPhysics;
  final List<PillSheetModifiedHistory> pillSheetModifiedHistories;

  final Future<void> Function(
    DateTime actualTakenDate,
    PillSheetModifiedHistory history,
    PillSheetModifiedHistoryValue value,
    TakenPillValue takenPillValue,
  )? onEditTakenPillAction;

  const CalendarPillSheetModifiedHistoryList({
    Key? key,
    required this.padding,
    required this.scrollPhysics,
    required this.pillSheetModifiedHistories,
    required this.onEditTakenPillAction,
  }) : super(key: key);

  List<CalendarPillSheetModifiedHistoryListModel> get models {
    final List<CalendarPillSheetModifiedHistoryListModel> models = [];
    pillSheetModifiedHistories.forEach((history) {
      CalendarPillSheetModifiedHistoryListModel? model;

      models.forEach((m) {
        if (isSameMonth(m.dateTimeOfMonth, history.estimatedEventCausingDate)) {
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
            dateTimeOfMonth: history.estimatedEventCausingDate,
            pillSheetModifiedHistories: [history],
          ),
        );
      }
    });
    return models;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding,
      shrinkWrap: true,
      physics: scrollPhysics,
      scrollDirection: Axis.vertical,
      children: models
          .map((model) {
            var dirtyIndex = 0;
            return [
              CalendarPillSheetModifiedHistoryMonthlyHeader(
                dateTimeOfMonth: model.dateTimeOfMonth,
              ),
              ...model.pillSheetModifiedHistories.map((history) {
                final actionType = history.enumActionType;
                if (actionType == null) {
                  return Container();
                }

                var isDotNecessary = false;
                if (dirtyIndex != 0) {
                  final oneNewlyHistory =
                      model.pillSheetModifiedHistories[dirtyIndex - 1];
                  final diff = oneNewlyHistory.estimatedEventCausingDate.day -
                      history.estimatedEventCausingDate.day;
                  if (diff > 1) {
                    isDotNecessary = true;
                  }
                }

                dirtyIndex += 1;
                final body = () {
                  switch (actionType) {
                    case PillSheetModifiedActionType.createdPillSheet:
                      return PillSheetModifiedHistoryCreatePillSheetAction(
                        estimatedEventCausingDate:
                            history.estimatedEventCausingDate,
                        value: history.value.createdPillSheet,
                      );
                    case PillSheetModifiedActionType
                        .automaticallyRecordedLastTakenDate:
                      return PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction(
                        estimatedEventCausingDate:
                            history.estimatedEventCausingDate,
                        value: history.value.automaticallyRecordedLastTakenDate,
                      );
                    case PillSheetModifiedActionType.deletedPillSheet:
                      return PillSheetModifiedHistoryDeletedPillSheetAction(
                        estimatedEventCausingDate:
                            history.estimatedEventCausingDate,
                        value: history.value.deletedPillSheet,
                      );
                    case PillSheetModifiedActionType.takenPill:
                      return PillSheetModifiedHistoryTakenPillAction(
                        onEdit: onEditTakenPillAction == null
                            ? null
                            : (actualDateTime, takenPillValue) {
                                return onEditTakenPillAction!(actualDateTime,
                                    history, history.value, takenPillValue);
                              },
                        estimatedEventCausingDate:
                            history.estimatedEventCausingDate,
                        value: history.value.takenPill,
                        beforePillSheet: history.before,
                        afterPillSheet: history.after,
                      );
                    case PillSheetModifiedActionType.revertTakenPill:
                      return PillSheetModifiedHistoryRevertTakenPillAction(
                        estimatedEventCausingDate:
                            history.estimatedEventCausingDate,
                        value: history.value.revertTakenPill,
                      );
                    case PillSheetModifiedActionType.changedPillNumber:
                      return PillSheetModifiedHistoryChangedPillNumberAction(
                        estimatedEventCausingDate:
                            history.estimatedEventCausingDate,
                        value: history.value.changedPillNumber,
                      );
                    case PillSheetModifiedActionType.endedPillSheet:
                      return PillSheetModifiedHistoryEndedPillSheetAction(
                        value: history.value.endedPillSheet,
                      );
                    case PillSheetModifiedActionType.beganRestDuration:
                      return PillSheetModifiedHistoryBeganRestDuration(
                        estimatedEventCausingDate:
                            history.estimatedEventCausingDate,
                        value: history.value.beganRestDurationValue,
                      );
                    case PillSheetModifiedActionType.endedRestDuration:
                      return PillSheetModifiedHistoryEndedRestDuration(
                        estimatedEventCausingDate:
                            history.estimatedEventCausingDate,
                        value: history.value.endedRestDurationValue,
                      );
                  }
                };

                if (isDotNecessary) {
                  return Column(children: [
                    Row(
                      children: [
                        SizedBox(width: 32),
                        SvgPicture.asset("images/vertical_dash_line.svg"),
                        Spacer(),
                      ],
                    ),
                    body(),
                  ]);
                }

                return body();
              }).toList()
            ];
          })
          .expand((element) => element)
          .toList(),
    );
  }
}
