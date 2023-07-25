import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/effective_pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/time.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/taken_pill_action_o_list.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:pilll/utils/toolbar/date_and_time_picker.dart';

class PillSheetModifiedHistoryTakenPillAction extends HookConsumerWidget {
  final PremiumAndTrial premiumAndTrial;
  final DateTime estimatedEventCausingDate;
  final PillSheetModifiedHistory history;
  final TakenPillValue? value;
  final PillSheet? beforePillSheet;
  final PillSheet? afterPillSheet;

  const PillSheetModifiedHistoryTakenPillAction({
    Key? key,
    required this.premiumAndTrial,
    required this.estimatedEventCausingDate,
    required this.history,
    required this.value,
    required this.beforePillSheet,
    required this.afterPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setPillSheetModifiedHistory = ref.watch(setPillSheetModifiedHistoryProvider);
    final value = this.value;
    final beforePillSheet = this.beforePillSheet;
    final afterPillSheet = this.afterPillSheet;
    if (value == null || afterPillSheet == null || beforePillSheet == null) {
      return Container();
    }

    final time = DateTimeFormatter.hourAndMinute(estimatedEventCausingDate);
    return GestureDetector(
      onTap: () {
        analytics.logEvent(name: "tapped_history_taken_action");

        if (premiumAndTrial.isPremium || premiumAndTrial.isTrial) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return DateAndTimePicker(
                initialDateTime: estimatedEventCausingDate,
                done: (dateTime) async {
                  analytics.logEvent(name: "selected_date_taken_history", parameters: {"hour": dateTime.hour, "minute": dateTime.minute});

                  try {
                    final messenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(context);
                    await updateTakenValue(
                      setPillSheetModifiedHistory: setPillSheetModifiedHistory,
                      actualTakenDate: dateTime,
                      history: history,
                      value: history.value,
                      takenPillValue: value,
                    );
                    final date = DateTimeFormatter.slashYearAndMonthAndDayAndTime(dateTime);
                    messenger.showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text("$dateに変更しました"),
                      ),
                    );
                    navigator.pop();
                  } catch (error) {
                    showErrorAlert(context, '更新に失敗しました。通信環境をお確かめの上、再度変更してください');
                  }
                },
              );
            },
          );
        }
      },
      child: RowLayout(
        day: Day(estimatedEventCausingDate: estimatedEventCausingDate),
        effectiveNumbersOrHyphen: EffectivePillNumber(effectivePillNumber: PillSheetModifiedHistoryDateEffectivePillNumber.taken(value)),
        detail: Time(time: time),
        takenPillActionOList: TakenPillActionOList(
          value: value,
          beforePillSheet: beforePillSheet,
          afterPillSheet: afterPillSheet,
        ),
      ),
    );
  }
}

class PillSheetModifiedHistoryTakenPillActionV2 extends HookConsumerWidget {
  final PremiumAndTrial premiumAndTrial;
  final DateTime estimatedEventCausingDate;
  final PillSheetModifiedHistory history;
  final TakenPillValue? value;
  final PillSheetGroup? beforePillSheetGroup;
  final PillSheetGroup? afterPillSheetGroup;

  const PillSheetModifiedHistoryTakenPillActionV2({
    Key? key,
    required this.premiumAndTrial,
    required this.estimatedEventCausingDate,
    required this.history,
    // TODO: Remove
    required this.value,
    required this.beforePillSheetGroup,
    required this.afterPillSheetGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beforePillSheet = beforePillSheetGroup?.activePillSheetWhen(estimatedEventCausingDate);
    final afterPillSheet = afterPillSheetGroup?.activePillSheetWhen(estimatedEventCausingDate);

    return PillSheetModifiedHistoryTakenPillAction(
        premiumAndTrial: premiumAndTrial,
        estimatedEventCausingDate: estimatedEventCausingDate,
        history: history,
        value: value,
        beforePillSheet: beforePillSheet,
        afterPillSheet: afterPillSheet);
  }
}

Future<void> updateTakenValue({
  required SetPillSheetModifiedHistory setPillSheetModifiedHistory,
  required DateTime actualTakenDate,
  required PillSheetModifiedHistory history,
  required PillSheetModifiedHistoryValue value,
  required TakenPillValue takenPillValue,
}) async {
  final editedTakenPillValue = takenPillValue.copyWith(
    edited: TakenPillEditedValue(
      createdDate: DateTime.now(),
      actualTakenDate: actualTakenDate,
      historyRecordedDate: history.estimatedEventCausingDate,
    ),
  );
  final editedHistory = history.copyWith(
    estimatedEventCausingDate: actualTakenDate,
    value: value.copyWith(
      takenPill: editedTakenPillValue,
    ),
  );

  await setPillSheetModifiedHistory(editedHistory);
}
