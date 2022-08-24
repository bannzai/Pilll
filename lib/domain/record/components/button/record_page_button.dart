import 'package:flutter/material.dart';
import 'package:pilll/domain/record/components/button/cancel_button.dart';
import 'package:pilll/domain/record/components/button/rest_duration_button.dart';
import 'package:pilll/domain/record/components/button/taken_button.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

class RecordPageButton extends StatelessWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet currentPillSheet;

  const RecordPageButton({
    Key? key,
    required this.pillSheetGroup,
    required this.currentPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentPillSheet.activeRestDuration != null) {
      return const RestDurationButton();
    } else if (currentPillSheet.todayPillIsAlreadyTaken) {
      return CancelButton(
        pillSheetGroup: pillSheetGroup,
        pillSheet: currentPillSheet,
      );
    } else {
      return TakenButton(
        parentContext: context,
        pillSheetGroup: pillSheetGroup,
        pillSheet: currentPillSheet,
      );
    }
  }
}
