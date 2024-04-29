import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/record/components/button/cancel_button.dart';
import 'package:pilll/features/record/components/button/rest_duration_button.dart';
import 'package:pilll/features/record/components/button/taken_button.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/utils/local_notification.dart';

class RecordPageButton extends HookConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet currentPillSheet;
  final bool userIsPremiumOtTrial;
  final User user;

  const RecordPageButton({
    super.key,
    required this.pillSheetGroup,
    required this.currentPillSheet,
    required this.userIsPremiumOtTrial,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerReminderLocalNotification = ref.watch(registerReminderLocalNotificationProvider);

    if (currentPillSheet.activeRestDuration != null) {
      return const RestDurationButton();
    } else if (currentPillSheet.todayPillIsAlreadyTaken) {
      return CancelButton(
        pillSheetGroup: pillSheetGroup,
        activePillSheet: currentPillSheet,
        userIsPremiumOtTrial: userIsPremiumOtTrial,
        registerReminderLocalNotification: registerReminderLocalNotification,
      );
    } else {
      return TakenButton(
        parentContext: context,
        pillSheetGroup: pillSheetGroup,
        activePillSheet: currentPillSheet,
        userIsPremiumOtTrial: userIsPremiumOtTrial,
        registerReminderLocalNotification: registerReminderLocalNotification,
      );
    }
  }
}
