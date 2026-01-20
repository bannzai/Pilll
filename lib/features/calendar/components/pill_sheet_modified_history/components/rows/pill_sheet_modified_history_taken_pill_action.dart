import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/time.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/taken_pill_action_o_list.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';
import 'package:pilll/components/picker/date_and_time_picker.dart';

class PillSheetModifiedHistoryTakenPillAction extends HookConsumerWidget {
  final bool premiumOrTrial;
  final DateTime estimatedEventCausingDate;
  final PillSheetModifiedHistory history;
  final TakenPillValue? value;

  const PillSheetModifiedHistoryTakenPillAction({
    super.key,
    required this.premiumOrTrial,
    required this.estimatedEventCausingDate,
    required this.history,
    required this.value,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setPillSheetModifiedHistory = ref.watch(
      setPillSheetModifiedHistoryProvider,
    );
    final value = this.value;
    final beforePillSheetGroup = history.beforePillSheetGroup;
    final afterPillSheetGroup = history.afterPillSheetGroup;
    if (value == null ||
        afterPillSheetGroup == null ||
        beforePillSheetGroup == null) {
      return Text(L.failedToGetPillSheetHistory('takenPill'));
    }

    final time = DateTimeFormatter.hourAndMinute(estimatedEventCausingDate);
    int?
    beforeLastTakenPillNumber = beforePillSheetGroup.pillNumberWithoutDateOrZero(
      // 例えば履歴の表示の際にbeforePillSheetGroupとafterPillSheetGroupのpillSheetAppearanceModeが違う場合があるので、afterPillSheetGroup.pillSheetAppearanceModeを引数にする
      pillSheetAppearanceMode: afterPillSheetGroup.pillSheetAppearanceMode,
      pageIndex:
          beforePillSheetGroup.lastTakenPillSheetOrFirstPillSheet.groupIndex,
      pillNumberInPillSheet: beforePillSheetGroup
          .lastTakenPillSheetOrFirstPillSheet
          .lastTakenOrZeroPillNumber,
    );
    // そのピルシートの服用番号が最後の場合は、1つ前のピルシートと認識する。その場合は表記を省略するためにnullにする
    if (beforeLastTakenPillNumber ==
        beforePillSheetGroup
            .activePillSheetWhen(estimatedEventCausingDate)
            ?.pillSheetType
            .totalCount) {
      beforeLastTakenPillNumber = null;
    }

    return GestureDetector(
      onTap: () {
        analytics.logEvent(name: 'tapped_history_taken_action');

        if (premiumOrTrial) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return DateAndTimePicker(
                initialDateTime: estimatedEventCausingDate,
                done: (dateTime) async {
                  analytics.logEvent(
                    name: 'selected_date_taken_history',
                    parameters: {
                      'hour': dateTime.hour,
                      'minute': dateTime.minute,
                    },
                  );

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
                    final date =
                        DateTimeFormatter.slashYearAndMonthAndDayAndTime(
                          dateTime,
                        );
                    messenger.showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text(L.changedToDate(date)),
                      ),
                    );
                    navigator.pop();
                  } catch (error) {
                    if (context.mounted)
                      showErrorAlert(context, L.failedToUpdate);
                  }
                },
              );
            },
          );
        }
      },
      child: RowLayout(
        day: Day(estimatedEventCausingDate: estimatedEventCausingDate),
        pillNumbersOrHyphenOrDate: PillNumber(
          pillNumber: switch (afterPillSheetGroup
              .lastTakenPillSheetOrFirstPillSheet) {
            PillSheetV1() => PillSheetModifiedHistoryPillNumberOrDate.taken(
              beforeLastTakenPillNumber: beforeLastTakenPillNumber,
              afterLastTakenPillNumber: afterPillSheetGroup
                  .pillNumberWithoutDateOrZero(
                    pillSheetAppearanceMode:
                        afterPillSheetGroup.pillSheetAppearanceMode,
                    pageIndex: afterPillSheetGroup
                        .lastTakenPillSheetOrFirstPillSheet
                        .groupIndex,
                    pillNumberInPillSheet: afterPillSheetGroup
                        .lastTakenPillSheetOrFirstPillSheet
                        .lastTakenOrZeroPillNumber,
                  ),
              pillSheetAppearanceMode:
                  afterPillSheetGroup.pillSheetAppearanceMode,
            ),
            PillSheetV2() => PillSheetModifiedHistoryPillNumberOrDate.takenV2(
              beforeLastTakenPillNumber: beforeLastTakenPillNumber,
              afterLastTakenPillNumber: afterPillSheetGroup
                  .pillNumberWithoutDateOrZero(
                    pillSheetAppearanceMode:
                        afterPillSheetGroup.pillSheetAppearanceMode,
                    pageIndex: afterPillSheetGroup
                        .lastTakenPillSheetOrFirstPillSheet
                        .groupIndex,
                    pillNumberInPillSheet: afterPillSheetGroup
                        .lastTakenPillSheetOrFirstPillSheet
                        .lastTakenOrZeroPillNumber,
                  ),
              pillSheetAppearanceMode:
                  afterPillSheetGroup.pillSheetAppearanceMode,
            ),
          },
        ),
        detail: Time(time: time),
        takenPillActionOList: TakenPillActionOList(
          beforePillSheetGroup: beforePillSheetGroup,
          afterPillSheetGroup: afterPillSheetGroup,
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
    value: value.copyWith(takenPill: editedTakenPillValue),
  );

  await setPillSheetModifiedHistory(editedHistory);
}
