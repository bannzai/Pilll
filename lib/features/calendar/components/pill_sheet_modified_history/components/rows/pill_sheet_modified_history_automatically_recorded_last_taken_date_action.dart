import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/effective_pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';

class PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final AutomaticallyRecordedLastTakenDateValue? value;

  const PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction({
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
    return _PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction(
      estimatedEventCausingDate: estimatedEventCausingDate,
      effectiveNumbersOrHyphen: EffectivePillNumber(
        effectivePillNumber: PillSheetModifiedHistoryDateEffectivePillNumber.autoTaken(
          beforeLastTakenPillNumber: value.beforeLastTakenPillNumber,
          afterLastTakenPillNumber: value.afterLastTakenPillNumber,
        ),
      ),
    );
  }
}

class PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateActionV2 extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final int beforeLastTakenPillNumber;
  final int afterLastTakenPillNumber;

  const PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateActionV2({
    Key? key,
    required this.estimatedEventCausingDate,
    required this.beforeLastTakenPillNumber,
    required this.afterLastTakenPillNumber,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return _PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction(
      estimatedEventCausingDate: estimatedEventCausingDate,
      effectiveNumbersOrHyphen: EffectivePillNumber(
        effectivePillNumber: PillSheetModifiedHistoryDateEffectivePillNumber.autoTaken(
          beforeLastTakenPillNumber: beforeLastTakenPillNumber,
          afterLastTakenPillNumber: afterLastTakenPillNumber,
        ),
      ),
    );
  }
}

class _PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction extends StatelessWidget {
  const _PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction({
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
