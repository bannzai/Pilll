import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/domain/record/record_page_state_notifier.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/native/widget.dart';

class CancelButton extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet pillSheet;
  final PillSheetAppearanceMode appearanceMode;
  final bool userIsPremiumOtTrial;

  const CancelButton({
    Key? key,
    required this.pillSheetGroup,
    required this.pillSheet,
    required this.appearanceMode,
    required this.userIsPremiumOtTrial,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(recordPageStateNotifierProvider.notifier);
    return UndoButton(
      text: "飲んでない",
      onPressed: () async {
        analytics.logEvent(name: "cancel_taken_button_pressed", parameters: {
          "last_taken_pill_number": pillSheet.lastTakenPillNumber,
          "today_pill_number": pillSheet.todayPillNumber,
        });

        if (!pillSheet.todayPillIsAlreadyTaken) {
          return;
        }
        final lastTakenDate = pillSheet.lastTakenDate;
        if (lastTakenDate == null) {
          return;
        }
        await store.asyncAction.cancelTaken(pillSheetGroup: pillSheetGroup);
        updateValuesForWidget(pillSheet: pillSheet, appearanceMode: appearanceMode, userIsPremiumOrTrial: userIsPremiumOtTrial);
      },
    );
  }
}
