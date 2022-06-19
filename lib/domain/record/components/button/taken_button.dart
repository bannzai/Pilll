import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/domain/modal/release_note.dart';
import 'package:pilll/domain/record/record_page_state_notifier.dart';
import 'package:pilll/domain/record/util/request_in_app_review.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/native/app_badge.dart';

class TakenButton extends HookConsumerWidget {
  final BuildContext parentContext;
  final PillSheetGroup pillSheetGroup;
  final PillSheet pillSheet;

  const TakenButton({
    Key? key,
    required this.parentContext,
    required this.pillSheetGroup,
    required this.pillSheet,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(recordPageStateNotifierProvider.notifier);

    return PrimaryButton(
      text: "飲んだ",
      onPressed: () async {
        try {
          analytics.logEvent(name: "taken_button_pressed", parameters: {
            "last_taken_pill_number": pillSheet.lastTakenPillNumber,
            "today_pill_number": pillSheet.todayPillNumber,
          });

          await store.asyncAction.taken(pillSheetGroup: pillSheetGroup);

          removeAppBadge();

          requestInAppReview();

          await showReleaseNotePreDialog(context);
        } catch (exception, stack) {
          errorLogger.recordError(exception, stack);
          showErrorAlert(context, message: exception.toString());
        }
      },
    );
  }
}
