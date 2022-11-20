import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_automatically_recorded_last_taken_date_action.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_began_rest_duration.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_begin_display_number_action.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_changed_pill_number_action.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_created_pill_sheet_action.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_deleted_pill_sheet_action.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_end_display_number_action.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_ended_rest_duration.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_ended_pill_sheet_action.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_monthly_header.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_revert_taken_pill_action.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/rows/pill_sheet_modified_history_taken_pill_action.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/util/datetime/date_compare.dart';

class PillSheetModifiedHistoryListModel {
  final DateTime dateTimeOfMonth;
  final List<PillSheetModifiedHistory> pillSheetModifiedHistories;
  PillSheetModifiedHistoryListModel({
    required this.dateTimeOfMonth,
    required this.pillSheetModifiedHistories,
  });
}

class PillSheetModifiedHistoryList extends StatelessWidget {
  final EdgeInsets? padding;
  final ScrollPhysics scrollPhysics;
  final List<PillSheetModifiedHistory> pillSheetModifiedHistories;
  final PremiumAndTrial premiumAndTrial;

  const PillSheetModifiedHistoryList({
    Key? key,
    required this.padding,
    required this.scrollPhysics,
    required this.pillSheetModifiedHistories,
    required this.premiumAndTrial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding,
      shrinkWrap: true,
      physics: scrollPhysics,
      scrollDirection: Axis.vertical,
      children: _summarizedForEachMonth.map((model) => _monthlyHeaderAndRelationaHistories(model)).expand((element) => element).toList(),
    );
  }

  List<Widget> _monthlyHeaderAndRelationaHistories(PillSheetModifiedHistoryListModel model) {
    var dirtyIndex = 0;

    return [
      PillSheetModifiedHistoryMonthlyHeader(
        dateTimeOfMonth: model.dateTimeOfMonth,
      ),
      const SizedBox(height: 16),
      ...model.pillSheetModifiedHistories
          .map((history) {
            final actionType = history.enumActionType;
            if (actionType == null) {
              return Container();
            }

            var isNecessaryDots = false;
            if (dirtyIndex != 0) {
              final oneBeforeHistory = model.pillSheetModifiedHistories[dirtyIndex - 1];
              final diff = oneBeforeHistory.estimatedEventCausingDate.day - history.estimatedEventCausingDate.day;
              if (diff > 1) {
                isNecessaryDots = true;
              }
            }

            dirtyIndex += 1;
            // ignore: prefer_function_declarations_over_variables
            final body = () {
              switch (actionType) {
                case PillSheetModifiedActionType.createdPillSheet:
                  return PillSheetModifiedHistoryCreatePillSheetAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.createdPillSheet,
                  );
                case PillSheetModifiedActionType.automaticallyRecordedLastTakenDate:
                  return PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.automaticallyRecordedLastTakenDate,
                  );
                case PillSheetModifiedActionType.deletedPillSheet:
                  return PillSheetModifiedHistoryDeletedPillSheetAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.deletedPillSheet,
                  );
                case PillSheetModifiedActionType.takenPill:
                  return PillSheetModifiedHistoryTakenPillAction(
                    premiumAndTrial: premiumAndTrial,
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    history: history,
                    value: history.value.takenPill,
                    beforePillSheet: history.before,
                    afterPillSheet: history.after,
                  );
                case PillSheetModifiedActionType.revertTakenPill:
                  return PillSheetModifiedHistoryRevertTakenPillAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.revertTakenPill,
                  );
                case PillSheetModifiedActionType.changedPillNumber:
                  return PillSheetModifiedHistoryChangedPillNumberAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.changedPillNumber,
                  );
                case PillSheetModifiedActionType.endedPillSheet:
                  return PillSheetModifiedHistoryEndedPillSheetAction(
                    value: history.value.endedPillSheet,
                  );
                case PillSheetModifiedActionType.beganRestDuration:
                  return PillSheetModifiedHistoryBeganRestDuration(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.beganRestDurationValue,
                  );
                case PillSheetModifiedActionType.endedRestDuration:
                  return PillSheetModifiedHistoryEndedRestDuration(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.endedRestDurationValue,
                  );
                case PillSheetModifiedActionType.changedBeginDisplayNumber:
                  return PillSheetModifiedHistoryChangedBeginDisplayNumberAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.changedBeginDisplayNumber,
                  );
                case PillSheetModifiedActionType.changedEndDisplayNumber:
                  return PillSheetModifiedHistoryChangedEndDisplayNumberAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.changedEndDisplayNumber,
                  );
              }
            };

            if (isNecessaryDots) {
              return Column(children: [
                Row(
                  children: [
                    SizedBox(
                      width: 56,
                      child: SvgPicture.asset("images/vertical_dash_line.svg"),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 16),
                body(),
              ]);
            } else {
              return body();
            }
          })
          .map((e) => Column(children: [e, const SizedBox(height: 16)]))
          .toList(),
    ];
  }

  List<PillSheetModifiedHistoryListModel> get _summarizedForEachMonth {
    final List<PillSheetModifiedHistoryListModel> models = [];
    for (var history in pillSheetModifiedHistories) {
      PillSheetModifiedHistoryListModel? model;

      for (var m in models) {
        if (isSameMonth(m.dateTimeOfMonth, history.estimatedEventCausingDate)) {
          model = m;
          continue;
        }
      }

      final m = model;
      if (m != null) {
        m.pillSheetModifiedHistories.add(history);
      } else {
        models.add(
          PillSheetModifiedHistoryListModel(
            dateTimeOfMonth: history.estimatedEventCausingDate,
            pillSheetModifiedHistories: [history],
          ),
        );
      }
    }
    return models;
  }
}
