import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/release_note/release_note.dart';
import 'package:pilll/features/record/util/request_in_app_review.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/native/widget.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/local_notification.dart';

class TakenButton extends HookConsumerWidget {
  final BuildContext parentContext;
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;
  final bool userIsPremiumOtTrial;
  final RegisterReminderLocalNotification registerReminderLocalNotification;
// TODO: [UseLocalNotification-Beta] 2024-04
  final User user;

  const TakenButton({
    Key? key,
    required this.parentContext,
    required this.pillSheetGroup,
    required this.activePillSheet,
    required this.userIsPremiumOtTrial,
    required this.registerReminderLocalNotification,
    required this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final takePill = ref.watch(takePillProvider);
    final updateUseLocalNotification = ref.watch(updateUseLocalNotificationProvider);

    return SizedBox(
      width: 180,
      child: PrimaryButton(
        text: "飲んだ",
        onPressed: () async {
          try {
            analytics.logEvent(name: "taken_button_pressed", parameters: {
              "last_taken_pill_number": activePillSheet.lastTakenPillNumber,
              "today_pill_number": activePillSheet.todayPillNumber,
            });
            // NOTE: batch.commit でリモートのDBに書き込む時間がかかるので事前にバッジを0にする
            FlutterAppBadger.removeBadge();
            requestInAppReview();
            showReleaseNotePreDialog(context);
            final updatedPillSheetGroup = await takePill(
              takenDate: now(),
              pillSheetGroup: pillSheetGroup,
              activePillSheet: activePillSheet,
              isQuickRecord: false,
            );
            syncActivePillSheetValue(pillSheetGroup: updatedPillSheetGroup);
            await registerReminderLocalNotification();
            if (!user.useLocalNotificationForReminder) {
              await updateUseLocalNotification(user, true);
            }
          } catch (exception, stack) {
            errorLogger.recordError(exception, stack);
            if (context.mounted) showErrorAlert(context, exception);
          }
        },
      ),
    );
  }
}
