import 'package:flutter/material.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/record/components/button/cancel_button.dart';
import 'package:pilll/features/record/components/button/rest_duration_button.dart';
import 'package:pilll/features/record/components/button/taken_button.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

class RecordPageButton extends StatelessWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet currentPillSheet;
  final bool userIsPremiumOtTrial;
  final Setting setting;

  const RecordPageButton({
    Key? key,
    required this.pillSheetGroup,
    required this.currentPillSheet,
    required this.userIsPremiumOtTrial,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentPillSheet.activeRestDuration != null) {
      return const RestDurationButton();
    } else if (currentPillSheet.todayPillIsAlreadyTaken) {
      return CancelButton(
        pillSheetGroup: pillSheetGroup,
        activePillSheet: currentPillSheet,
        userIsPremiumOtTrial: userIsPremiumOtTrial,
      );
    } else {
      return TakenButton(
        parentContext: context,
        pillSheetGroup: pillSheetGroup,
        activePillSheet: currentPillSheet,
        setting: setting,
        userIsPremiumOtTrial: userIsPremiumOtTrial,
      );
    }
  }
}
