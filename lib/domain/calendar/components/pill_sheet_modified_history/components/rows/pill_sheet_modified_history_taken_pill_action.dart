import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/core/effective_pill_number.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/core/time.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/core/taken_pill_action_o_list.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:pilll/util/toolbar/date_and_time_picker.dart';

class PillSheetModifiedHistoryTakenPillAction extends StatelessWidget {
  final Future<void> Function(
    DateTime actualTakenDate,
    TakenPillValue value,
  )? onEdit;

  final DateTime estimatedEventCausingDate;
  final TakenPillValue? value;
  final PillSheet? beforePillSheet;
  final PillSheet? afterPillSheet;

  const PillSheetModifiedHistoryTakenPillAction({
    Key? key,
    required this.onEdit,
    required this.estimatedEventCausingDate,
    required this.value,
    required this.beforePillSheet,
    required this.afterPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

        final onEdit = this.onEdit;
        if (onEdit != null) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return DateAndTimePicker(
                initialDateTime: estimatedEventCausingDate,
                done: (dateTime) async {
                  analytics.logEvent(
                      name: "selected_date_taken_history",
                      parameters: {
                        "hour": dateTime.hour,
                        "minute": dateTime.minute
                      });

                  try {
                    await onEdit(dateTime, value);
                    final date =
                        DateTimeFormatter.slashYearAndMonthAndDayAndTime(
                            dateTime);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text("$dateに変更しました"),
                      ),
                    );
                    Navigator.pop(context);
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
        effectiveNumbersOrHyphen: EffectivePillNumber(
            effectivePillNumber:
                PillSheetModifiedHistoryDateEffectivePillNumber.taken(value)),
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
