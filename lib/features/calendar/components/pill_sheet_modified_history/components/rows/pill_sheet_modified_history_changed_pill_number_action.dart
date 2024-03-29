import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';

class PillSheetModifiedHistoryChangedPillNumberAction extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final int? beforeTodayPillNumber;
  final int? afterTodayPillNumber;

  const PillSheetModifiedHistoryChangedPillNumberAction({
    Key? key,
    required this.estimatedEventCausingDate,
    required this.beforeTodayPillNumber,
    required this.afterTodayPillNumber,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final beforeTodayPillNumber = this.beforeTodayPillNumber;
    final afterTodayPillNumber = this.afterTodayPillNumber;
    if (beforeTodayPillNumber == null || afterTodayPillNumber == null) {
      return Container();
    }
    return RowLayout(
      day: Day(estimatedEventCausingDate: estimatedEventCausingDate),
      pillNumbersOrHyphenOrDate: PillNumber(
          pillNumber: PillSheetModifiedHistoryPillNumberOrDate.changed(
        beforeTodayPillNumber: beforeTodayPillNumber,
        afterTodayPillNumber: afterTodayPillNumber,
      )),
      detail: const Text(
        "ピル番号変更",
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
