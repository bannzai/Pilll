import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/pill_number.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/features/localizations/l.dart';

class PillSheetModifiedHistoryRevertTakenPillAction extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final PillSheetModifiedHistory history;

  const PillSheetModifiedHistoryRevertTakenPillAction({
    super.key,
    required this.estimatedEventCausingDate,
    required this.history,
  });
  @override
  Widget build(BuildContext context) {
    final beforePillSheetGroup = history.beforePillSheetGroup;
    final afterPillSheetGroup = history.afterPillSheetGroup;
    if (beforePillSheetGroup == null || afterPillSheetGroup == null) {
      return Text(L.failedToGetPillSheetHistory('revertTakenPill'));
    }
    final beforeLastTakenPillNumber = beforePillSheetGroup.pillNumberWithoutDateOrZero(
      // 例えば履歴の表示の際にbeforePillSheetGroupとafterPillSheetGroupのpillSheetAppearanceModeが違う場合があるので、afterPillSheetGroup.pillSheetAppearanceModeを引数にする
      pillSheetAppearanceMode: afterPillSheetGroup.pillSheetAppearanceMode,
      pageIndex: beforePillSheetGroup.lastTakenPillSheetOrFirstPillSheet.groupIndex,
      pillNumberInPillSheet: beforePillSheetGroup.lastTakenPillSheetOrFirstPillSheet.lastTakenOrZeroPillNumber,
    );
    final afterLastTakenPillNumber = afterPillSheetGroup.pillNumberWithoutDateOrZero(
      pillSheetAppearanceMode: afterPillSheetGroup.pillSheetAppearanceMode,
      pageIndex: afterPillSheetGroup.lastTakenPillSheetOrFirstPillSheet.groupIndex,
      pillNumberInPillSheet: afterPillSheetGroup.lastTakenPillSheetOrFirstPillSheet.lastTakenOrZeroPillNumber,
    );
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
