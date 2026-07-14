import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/release_note/release_note.dart';
import 'package:pilll/features/record/util/request_in_app_review.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/error/error_alert.dart';
import 'package:pilll/features/record/components/button/midnight_taken_warning_dialog.dart';
import 'package:pilll/utils/error_log.dart';
import 'package:pilll/native/widget.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/local_notification.dart';

class TakenButton extends ConsumerWidget {
  final BuildContext parentContext;
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;
  final bool userIsPremiumOtTrial;

  /// 深夜(0:00-2:00)服用記録の注意ダイアログの表示判定・文言に使う
  final Setting setting;
  final RegisterReminderLocalNotification registerReminderLocalNotification;

  const TakenButton({
    super.key,
    required this.parentContext,
    required this.pillSheetGroup,
    required this.activePillSheet,
    required this.userIsPremiumOtTrial,
    required this.setting,
    required this.registerReminderLocalNotification,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final takePill = ref.watch(takePillProvider);

    return SizedBox(
      width: 180,
      child: PrimaryButton(
        text: L.taken,
        onPressed: () async {
          try {
            analytics.logEvent(
              name: 'taken_button_pressed',
              parameters: {
                'last_taken_pill_number': activePillSheet.lastTakenOrZeroPillNumber,
                'today_pill_number': activePillSheet.todayPillNumber,
              },
            );
            requestInAppReview();
            showReleaseNotePreDialog(context);
            final takenDate = now();
            // 深夜服用の注意ダイアログは服用記録の完了(await)を待たずに表示するため、awaitの前に服用記録を開始する
            final updatedPillSheetGroupFuture = takePill(
              takenDate: takenDate,
              pillSheetGroup: pillSheetGroup,
              activePillSheet: activePillSheet,
              isQuickRecord: false,
            );
            showMidnightTakenWarningDialogIfNeeded(
              context: context,
              takenDate: takenDate,
              recordedAt: takenDate,
              setting: setting,
            );
            final updatedPillSheetGroup = await updatedPillSheetGroupFuture;
            syncActivePillSheetValue(pillSheetGroup: updatedPillSheetGroup);
            await registerReminderLocalNotification();
          } catch (exception, stack) {
            errorLogger.recordError(exception, stack);
            if (context.mounted) showErrorAlert(context, exception);
          } finally {
            FlutterAppBadger.removeBadge();
          }
        },
      ),
    );
  }
}
