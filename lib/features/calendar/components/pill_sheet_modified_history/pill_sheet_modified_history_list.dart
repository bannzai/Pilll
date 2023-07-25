import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
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
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';

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
      children: _summarizedForEachMonth.map((model) => _monthlyHeaderAndRelativedHistories(model)).expand((element) => element).toList(),
    );
  }

  List<Widget> _monthlyHeaderAndRelativedHistories(PillSheetModifiedHistoryListModel model) {
    var dirtyIndex = 0;

    return [
      PillSheetModifiedHistoryMonthlyHeader(
        dateTimeOfMonth: model.dateTimeOfMonth,
      ),
      const SizedBox(height: 16),
      ...model.pillSheetModifiedHistories
          .where((history) => history.enumActionType != null)
          .map((history) {
            var isNecessaryDots = false;
            if (dirtyIndex != 0) {
              final previousHistory = model.pillSheetModifiedHistories[dirtyIndex - 1];
              final diff = daysBetween(previousHistory.estimatedEventCausingDate, history.estimatedEventCausingDate);
              if (diff > 1) {
                isNecessaryDots = true;
              }
            }

            dirtyIndex += 1;
            final Widget body;
            if (history.version == "v2") {
              // TODO: Use sealed class
              body = switch (history.enumActionType) {
                PillSheetModifiedActionType.createdPillSheet => PillSheetModifiedHistoryCreatePillSheetAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    pillSheetIDs: history.afterPillSheetGroup?.pillSheetIDs ?? [],
                  ),
                PillSheetModifiedActionType.automaticallyRecordedLastTakenDate => PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    beforeLastTakenPillNumber: history.beforePillSheet?.lastTakenPillNumber,
                    afterLastTakenPillNumber: history.afterPillSheet?.lastTakenPillNumber,
                  ),
                PillSheetModifiedActionType.deletedPillSheet => PillSheetModifiedHistoryDeletedPillSheetAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate, pillSheetIDs: history.afterPillSheetGroup?.pillSheetIDs),
                PillSheetModifiedActionType.takenPill => PillSheetModifiedHistoryTakenPillAction(
                    premiumAndTrial: premiumAndTrial,
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    history: history,
                    value: history.value.takenPill,
                    beforePillSheet: history.beforePillSheet,
                    afterPillSheet: history.afterPillSheet,
                  ),
                PillSheetModifiedActionType.revertTakenPill => PillSheetModifiedHistoryRevertTakenPillAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    beforeLastTakenPillNumber: history.beforePillSheet?.lastTakenPillNumber,
                    afterLastTakenPillNumber: history.afterPillSheet?.lastTakenPillNumber,
                  ),
                PillSheetModifiedActionType.changedPillNumber => PillSheetModifiedHistoryChangedPillNumberAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    beforeTodayPillNumber: history.beforePillSheet?.pillNumberFor(targetDate: history.estimatedEventCausingDate),
                    afterTodayPillNumber: history.afterPillSheet?.pillNumberFor(targetDate: history.estimatedEventCausingDate),
                  ),
                PillSheetModifiedActionType.endedPillSheet => PillSheetModifiedHistoryEndedPillSheetAction(
                    value: history.value.endedPillSheet,
                  ),
                PillSheetModifiedActionType.beganRestDuration => PillSheetModifiedHistoryBeganRestDuration(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.beganRestDurationValue,
                  ),
                PillSheetModifiedActionType.endedRestDuration => PillSheetModifiedHistoryEndedRestDuration(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.endedRestDurationValue,
                  ),
                PillSheetModifiedActionType.changedBeginDisplayNumber => PillSheetModifiedHistoryChangedBeginDisplayNumberAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.changedBeginDisplayNumber,
                  ),
                PillSheetModifiedActionType.changedEndDisplayNumber => PillSheetModifiedHistoryChangedEndDisplayNumberAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.changedEndDisplayNumber,
                  ),
                // whereでフィルタリングしているのでありえないパターン
                null => Container(),
              };
            } else {
              body = switch (history.enumActionType) {
                PillSheetModifiedActionType.createdPillSheet => PillSheetModifiedHistoryCreatePillSheetAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    pillSheetIDs: history.value.createdPillSheet?.pillSheetIDs ?? [],
                  ),
                PillSheetModifiedActionType.automaticallyRecordedLastTakenDate => PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    beforeLastTakenPillNumber: history.value.automaticallyRecordedLastTakenDate?.beforeLastTakenPillNumber,
                    afterLastTakenPillNumber: history.value.automaticallyRecordedLastTakenDate?.afterLastTakenPillNumber,
                  ),
                PillSheetModifiedActionType.deletedPillSheet => PillSheetModifiedHistoryDeletedPillSheetAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    pillSheetIDs: history.value.deletedPillSheet?.pillSheetIDs,
                  ),
                PillSheetModifiedActionType.takenPill => PillSheetModifiedHistoryTakenPillAction(
                    premiumAndTrial: premiumAndTrial,
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    history: history,
                    value: history.value.takenPill,
                    beforePillSheet: history.before,
                    afterPillSheet: history.after,
                  ),
                PillSheetModifiedActionType.revertTakenPill => PillSheetModifiedHistoryRevertTakenPillAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    beforeLastTakenPillNumber: history.value.revertTakenPill?.beforeLastTakenPillNumber,
                    afterLastTakenPillNumber: history.value.revertTakenPill?.afterLastTakenPillNumber,
                  ),
                PillSheetModifiedActionType.changedPillNumber => PillSheetModifiedHistoryChangedPillNumberAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    beforeTodayPillNumber: history.value.changedPillNumber?.beforeTodayPillNumber,
                    afterTodayPillNumber: history.value.changedPillNumber?.afterTodayPillNumber,
                  ),
                PillSheetModifiedActionType.endedPillSheet => PillSheetModifiedHistoryEndedPillSheetAction(
                    value: history.value.endedPillSheet,
                  ),
                PillSheetModifiedActionType.beganRestDuration => PillSheetModifiedHistoryBeganRestDuration(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.beganRestDurationValue,
                  ),
                PillSheetModifiedActionType.endedRestDuration => PillSheetModifiedHistoryEndedRestDuration(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.endedRestDurationValue,
                  ),
                PillSheetModifiedActionType.changedBeginDisplayNumber => PillSheetModifiedHistoryChangedBeginDisplayNumberAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.changedBeginDisplayNumber,
                  ),
                PillSheetModifiedActionType.changedEndDisplayNumber => PillSheetModifiedHistoryChangedEndDisplayNumberAction(
                    estimatedEventCausingDate: history.estimatedEventCausingDate,
                    value: history.value.changedEndDisplayNumber,
                  ),
                // whereでフィルタリングしているのでありえないパターン
                null => Container(),
              };
            }

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
                body,
              ]);
            } else {
              return body;
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
