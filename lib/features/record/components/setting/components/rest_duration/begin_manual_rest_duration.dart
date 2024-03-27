import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/features/record/components/pill_sheet/components/record_page_rest_duration_dialog.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/invalid_already_taken_pill_dialog.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/provider.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/utils/local_notification.dart';

class BeginManualRestDuration extends HookConsumerWidget {
  final PillSheetAppearanceMode appearanceMode;
  final PillSheet activePillSheet;
  final PillSheetGroup pillSheetGroup;
  final VoidCallback didBeginRestDuration;

  const BeginManualRestDuration({
    super.key,
    required this.appearanceMode,
    required this.activePillSheet,
    required this.pillSheetGroup,
    required this.didBeginRestDuration,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beginRestDuration = ref.watch(beginRestDurationProvider);
    final cancelReminderLocalNotification = ref.watch(cancelReminderLocalNotificationProvider);

    return GestureDetector(
      child: const Row(children: [
        Icon(Icons.stop_circle, color: PilllColors.primary),
        SizedBox(width: 6),
        Text(
          "服用お休み開始",
          style: TextStyle(
            color: TextColor.main,
            fontSize: 12,
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w700,
          ),
        ),
      ]),
      onTap: () {
        analytics.logEvent(name: "begin_manual_rest_duration_pressed", parameters: {"pill_sheet_id": activePillSheet.id});

        if (activePillSheet.todayPillIsAlreadyTaken) {
          showInvalidAlreadyTakenPillDialog(context);
        } else {
          showRecordPageRestDurationDialog(
            context,
            appearanceMode: appearanceMode,
            pillSheetGroup: pillSheetGroup,
            onDone: () async {
              analytics.logEvent(name: "done_rest_duration");
              // NOTE: batch.commit でリモートのDBに書き込む時間がかかるので事前にバッジを0にする
              FlutterAppBadger.removeBadge();
              await beginRestDuration(
                pillSheetGroup: pillSheetGroup,
              );
              await cancelReminderLocalNotification();
              didBeginRestDuration();
            },
          );
        }
      },
    );
  }
}
