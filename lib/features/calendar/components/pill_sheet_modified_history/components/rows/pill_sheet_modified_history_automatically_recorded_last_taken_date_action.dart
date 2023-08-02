import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/effective_pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';

class PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final int? beforeLastTakenPillNumber;
  final int? afterLastTakenPillNumber;

  const PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction({
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
      effectiveNumbersOrHyphen: EffectivePillNumber(
          effectivePillNumber: PillSheetModifiedHistoryDateEffectivePillNumber.autoTaken(
        beforeLastTakenPillNumber: beforeLastTakenPillNumber,
        afterLastTakenPillNumber: afterLastTakenPillNumber,
      )),
      detail: const Text(
        "-",
        style: TextStyle(
          color: TextColor.main,
          fontSize: 12,
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
