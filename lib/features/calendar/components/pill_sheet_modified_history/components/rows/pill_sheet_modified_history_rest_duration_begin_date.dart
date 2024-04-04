import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';

class PillSheetModifiedHistoryChangedRestDurationBeginDate extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final ChangedRestDurationBeginDateValue? value;

  const PillSheetModifiedHistoryChangedRestDurationBeginDate({
    Key? key,
    required this.estimatedEventCausingDate,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value == null) {
      return Container();
    }
    return RowLayout(
      day: Day(estimatedEventCausingDate: estimatedEventCausingDate),
      pillNumbersOrHyphenOrDate: PillNumber(pillNumber: PillSheetModifiedHistoryPillNumberOrDate.changedRestDurationBeginDate(value)),
      detail: const Text(
        "服用お休み開始日変更",
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
