import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/native/widget.dart';
import 'package:pilll/provider/revert_take_pill.dart';

class CancelButton extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;
  final bool userIsPremiumOtTrial;

  const CancelButton({
    Key? key,
    required this.pillSheetGroup,
    required this.activePillSheet,
    required this.userIsPremiumOtTrial,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revertTakePill = ref.watch(revertTakePillProvider);
    return UndoButton(
      text: "飲んでない",
      onPressed: () async {
        analytics.logEvent(name: "cancel_taken_button_pressed", parameters: {
          "last_taken_pill_number": activePillSheet.lastCompletedPillNumber,
          "today_pill_number": activePillSheet.todayPillNumber,
        });

        final updatedPillSheetGroup = await _cancelTaken(revertTakePill);
        syncActivePillSheetValue(pillSheetGroup: updatedPillSheetGroup);
      },
    );
  }

  Future<PillSheetGroup?> _cancelTaken(RevertTakePill revertTakePill) async {
    // 「飲んでない」ボタンを押したときは本日分の服用のundo機能になる。なので、すべて服用済みじゃない場合はreturnする
    if (!activePillSheet.todayPillsAreAlreadyTaken) {
      return null;
    }

    return await revertTakePill(
      pillSheetGroup: pillSheetGroup,
      pageIndex: activePillSheet.groupIndex,
      pillNumberIntoPillSheet: activePillSheet.lastCompletedPillNumber,
    );
  }
}
