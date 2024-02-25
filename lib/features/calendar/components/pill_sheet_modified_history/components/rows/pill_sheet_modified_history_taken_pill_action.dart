import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/time.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/taken_pill_action_o_list.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:pilll/utils/toolbar/date_and_time_picker.dart';

class PillSheetModifiedHistoryTakenPillAction extends HookConsumerWidget {
  final bool premiumOrTrial;
  final DateTime estimatedEventCausingDate;
  final PillSheetModifiedHistory history;
  final TakenPillValue? value;
  final PillSheet? beforePillSheet;
  final PillSheet? afterPillSheet;

  const PillSheetModifiedHistoryTakenPillAction({
    Key? key,
    required this.premiumOrTrial,
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

        if (premiumOrTrial) {
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
                    if (context.mounted) showErrorAlert(context, '更新に失敗しました。通信環境をお確かめの上、再度変更してください');
                  }
                },
              );
            },
          );
        }
      },
      child: RowLayout(
        day: Day(estimatedEventCausingDate: estimatedEventCausingDate),
        pillNumbersOrHyphen: PillNumber(
            pillNumber: PillSheetModifiedHistoryPillNumberOrDate.taken(
          beforeLastTakenPillNumber: beforePillSheet.lastTakenPillNumber,
          afterLastTakenPillNumber: afterPillSheet.lastTakenPillNumber,
        )),
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
