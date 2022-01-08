import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_date_component.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/taken_pill_action_o_list.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 2),
                        content: Text("変更しました"),
                      ),
                    );
                    Navigator.pop(context);
                  } catch (error) {
                    showErrorAlert(context,
                        message: '更新に失敗しました。通信環境をお確かめの上、再度変更してください');
                  }
                },
              );
            },
          );
        }
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Row(
            children: [
              PillSheetModifiedHistoryDate(
                estimatedEventCausingDate: estimatedEventCausingDate,
                effectivePillNumber:
                    PillSheetModifiedHistoryDateEffectivePillNumber.taken(
                        value),
              ),
              Spacer(),
              Container(
                constraints: BoxConstraints(
                  maxWidth:
                      PillSheetModifiedHistoryTakenActionLayoutWidths.trailing,
                ),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        time,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          letterSpacing: 1.5,
                          color: TextColor.main,
                          fontSize: 15,
                          fontFamily: FontFamily.number,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: PillSheetModifiedHistoryTakenActionLayoutWidths
                          .takenMark,
                      padding: EdgeInsets.only(left: 8),
                      child: TakenPillActionOList(
                        value: value,
                        beforePillSheet: beforePillSheet,
                        afterPillSheet: afterPillSheet,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
