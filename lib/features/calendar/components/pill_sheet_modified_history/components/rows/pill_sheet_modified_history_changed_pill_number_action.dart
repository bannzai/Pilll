import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/features/localizations/l.dart';

class PillSheetModifiedHistoryChangedPillNumberAction extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final PillSheetModifiedHistory history;

  const PillSheetModifiedHistoryChangedPillNumberAction({
    super.key,
    required this.estimatedEventCausingDate,
    required this.history,
  });
  @override
  Widget build(BuildContext context) {
    final beforePillSheetGroup = history.beforePillSheetGroup;
    final afterPillSheetGroup = history.afterPillSheetGroup;
    if (beforePillSheetGroup == null || afterPillSheetGroup == null) {
      return Text(L.failedToGetPillSheetHistory('changedPillNumber'));
    }
    final beforeTodayPillNumber = beforePillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
      pillSheetAppearanceMode: afterPillSheetGroup.pillSheetAppearanceMode,
      targetDate: estimatedEventCausingDate,
      estimatedEventCausingDate: estimatedEventCausingDate,
    );
    final afterTodayPillNumber = afterPillSheetGroup.pillNumberWithoutDateOrZeroFromDate(
      pillSheetAppearanceMode: afterPillSheetGroup.pillSheetAppearanceMode,
      targetDate: estimatedEventCausingDate,
      estimatedEventCausingDate: estimatedEventCausingDate,
    );

    return RowLayout(
      day: Day(estimatedEventCausingDate: estimatedEventCausingDate),
      pillNumbersOrHyphenOrDate: PillNumber(
        pillNumber: PillSheetModifiedHistoryPillNumberOrDate.changedPillNumber(
          beforeTodayPillNumber: beforeTodayPillNumber,
          afterTodayPillNumber: afterTodayPillNumber,
          pillSheetAppearanceMode: afterPillSheetGroup.pillSheetAppearanceMode,
        ),
      ),
      detail: Text(
        L.changedPillNumber,
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
