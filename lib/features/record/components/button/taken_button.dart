import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/util/analytics.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/modal/release_note.dart';
import 'package:pilll/features/record/util/request_in_app_review.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/util/error_log.dart';
import 'package:pilll/native/widget.dart';
import 'package:pilll/provider/take_pill.dart';
import 'package:pilll/util/datetime/day.dart';

class TakenButton extends HookConsumerWidget {
  final BuildContext parentContext;
  final PillSheetGroup pillSheetGroup;
  final PillSheet activePillSheet;
  final bool userIsPremiumOtTrial;

  const TakenButton({
    Key? key,
    required this.parentContext,
    required this.pillSheetGroup,
    required this.activePillSheet,
    required this.userIsPremiumOtTrial,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final takePill = ref.watch(takePillProvider);

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
              activedPillSheet: activePillSheet,
              isQuickRecord: false,
            );
            syncActivePillSheetValue(pillSheetGroup: updatedPillSheetGroup);
          } catch (exception, stack) {
            errorLogger.recordError(exception, stack);
            showErrorAlert(context, exception);
          }
        },
      ),
    );
  }
}
