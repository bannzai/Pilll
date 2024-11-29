import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/features/localizations/l.dart';

class PillSheetModifiedHistoryRevertTakenPillAction extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final int? beforeLastTakenPillNumber;
  final int? afterLastTakenPillNumber;

  const PillSheetModifiedHistoryRevertTakenPillAction({
    super.key,
    required this.estimatedEventCausingDate,
    required this.beforeLastTakenPillNumber,
    required this.afterLastTakenPillNumber,
  });
  @override
  Widget build(BuildContext context) {
    final beforeLastTakenPillNumber = this.beforeLastTakenPillNumber;
    final afterLastTakenPillNumber = this.afterLastTakenPillNumber;
    if (beforeLastTakenPillNumber == null || afterLastTakenPillNumber == null) {
      return Container();
    }
    return RowLayout(
      day: Day(estimatedEventCausingDate: estimatedEventCausingDate),
      pillNumbersOrHyphenOrDate: PillNumber(
          pillNumber: PillSheetModifiedHistoryPillNumberOrDate.revert(
        beforeLastTakenPillNumber: beforeLastTakenPillNumber,
        afterLastTakenPillNumber: afterLastTakenPillNumber,
      )),
      detail: Text(
        L.cancelTaking,
        style: const TextStyle(
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
