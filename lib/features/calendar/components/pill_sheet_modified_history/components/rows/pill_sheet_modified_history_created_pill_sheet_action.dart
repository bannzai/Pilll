import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/effective_pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';

class PillSheetModifiedHistoryCreatePillSheetAction extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final CreatedPillSheetValue? value;

  const PillSheetModifiedHistoryCreatePillSheetAction({
    Key? key,
    required this.estimatedEventCausingDate,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PillSheetModifiedHistoryCreatePillSheetAction(
      estimatedEventCausingDate: estimatedEventCausingDate,
      effectiveNumbersOrHyphen: EffectivePillNumber(
        effectivePillNumber: PillSheetModifiedHistoryDateEffectivePillNumber.pillSheetCount(value?.pillSheetIDs ?? []),
      ),
    );
  }
}

class _PillSheetModifiedHistoryCreatePillSheetAction extends StatelessWidget {
  const _PillSheetModifiedHistoryCreatePillSheetAction({
    required this.estimatedEventCausingDate,
    required this.effectiveNumbersOrHyphen,
  });

  final DateTime estimatedEventCausingDate;
  final Widget effectiveNumbersOrHyphen;

  @override
  Widget build(BuildContext context) {
    return RowLayout(
      day: Day(estimatedEventCausingDate: estimatedEventCausingDate),
      effectiveNumbersOrHyphen: effectiveNumbersOrHyphen,
      detail: const Text(
        "ピルシート追加",
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

class PillSheetModifiedHistoryCreatePillSheetActionV2 extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final PillSheetGroup? afterPillSheetGroup;

  const PillSheetModifiedHistoryCreatePillSheetActionV2({
    Key? key,
    required this.estimatedEventCausingDate,
    required this.afterPillSheetGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PillSheetModifiedHistoryCreatePillSheetAction(
      estimatedEventCausingDate: estimatedEventCausingDate,
      effectiveNumbersOrHyphen: EffectivePillNumber(
        effectivePillNumber: PillSheetModifiedHistoryDateEffectivePillNumber.pillSheetCount(afterPillSheetGroup?.pillSheetIDs ?? []),
      ),
    );
  }
}
