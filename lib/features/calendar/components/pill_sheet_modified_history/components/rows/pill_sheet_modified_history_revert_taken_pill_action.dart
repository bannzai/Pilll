import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';

class PillSheetModifiedHistoryRevertTakenPillAction extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final int? beforeLastTakenPillNumber;
  final int? afterLastTakenPillNumber;

  const PillSheetModifiedHistoryRevertTakenPillAction({
    Key? key,
    required this.estimatedEventCausingDate,
    required this.beforeLastTakenPillNumber,
    required this.afterLastTakenPillNumber,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final beforeLastTakenPillNumber = this.beforeLastTakenPillNumber;
    final afterLastTakenPillNumber = this.afterLastTakenPillNumber;
    if (beforeLastTakenPillNumber == null || afterLastTakenPillNumber == null) {
      return Container();
    }
    return RowLayout(
      day: Day(estimatedEventCausingDate: estimatedEventCausingDate),
      pillNumbersOrHyphen: PillNumber(
          pillNumber: PillSheetModifiedHistoryPillNumberOrDate.revert(
        beforeLastTakenPillNumber: beforeLastTakenPillNumber,
        afterLastTakenPillNumber: afterLastTakenPillNumber,
      )),
      detail: const Text(
        "服用取り消し",
        style: TextStyle(
          color: TextColor.main,
          fontSize: 12,
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}
