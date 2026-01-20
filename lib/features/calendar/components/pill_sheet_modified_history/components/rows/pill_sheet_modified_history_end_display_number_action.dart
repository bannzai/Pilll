import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/features/localizations/l.dart';

class PillSheetModifiedHistoryChangedEndDisplayNumberAction
    extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final PillSheetGroup? beforePillSheetGroup;
  final PillSheetGroup? afterPillSheetGroup;

  const PillSheetModifiedHistoryChangedEndDisplayNumberAction({
    super.key,
    required this.estimatedEventCausingDate,
    required this.beforePillSheetGroup,
    required this.afterPillSheetGroup,
  });
  @override
  Widget build(BuildContext context) {
    if (afterPillSheetGroup == null) {
      return Container();
    }
    return RowLayout(
      day: Day(estimatedEventCausingDate: estimatedEventCausingDate),
      pillNumbersOrHyphenOrDate: PillNumber(
        pillNumber:
            PillSheetModifiedHistoryPillNumberOrDate.changedEndDisplayNumberSetting(
              beforePillSheetGroup: beforePillSheetGroup,
              afterPillSheetGroup: afterPillSheetGroup,
            ),
      ),
      detail: Text(
        L.changeEndOfPillDays,
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
