import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/record/components/button/cancel_button.dart';
import 'package:pilll/features/record/components/button/rest_duration_button.dart';
import 'package:pilll/features/record/components/button/taken_button.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/utils/local_notification.dart';

class RecordPageButton extends ConsumerWidget {
  final PillSheetGroup pillSheetGroup;
  final PillSheet currentPillSheet;
  final bool userIsPremiumOtTrial;
  final User user;

  /// TakenButtonの深夜(0:00-2:00)服用記録の注意ダイアログの表示判定・文言に使う
  final Setting setting;

  const RecordPageButton({
    super.key,
    required this.pillSheetGroup,
    required this.currentPillSheet,
    required this.userIsPremiumOtTrial,
    required this.user,
    required this.setting,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerReminderLocalNotification = ref.watch(
      registerReminderLocalNotificationProvider,
    );

    final todayPillAllTaken = switch (currentPillSheet) {
      PillSheetV1 v1 => v1.todayPillIsAlreadyTaken,
      PillSheetV2 v2 => v2.todayPillAllTaken,
    };

    if (pillSheetGroup.lastActiveRestDuration != null) {
      return const RestDurationButton();
    } else if (todayPillAllTaken) {
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
        setting: setting,
        registerReminderLocalNotification: registerReminderLocalNotification,
      );
    }
  }
}
