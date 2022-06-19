import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/domain/record/components/pill_sheet/components/record_page_rest_duration_dialog.dart';
import 'package:pilll/domain/record/components/supports/components/rest_duration/invalid_already_taken_pill_dialog.dart';
import 'package:pilll/domain/record/record_page_state_notifier.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/native/app_badge.dart';

class BeginManualRestDurationButton extends StatelessWidget {
  final PillSheetAppearanceMode appearanceMode;
  final PillSheet activedPillSheet;
  final PillSheetGroup pillSheetGroup;
  final RecordPageStateNotifier store;
  final VoidCallback didBeginRestDuration;

  const BeginManualRestDurationButton({
    Key? key,
    required this.appearanceMode,
    required this.activedPillSheet,
    required this.pillSheetGroup,
    required this.store,
    required this.didBeginRestDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: SmallAppOutlinedButton(
        text: "休薬する",
        onPressed: () async {
          analytics.logEvent(
              name: "begin_manual_rest_duration_pressed",
              parameters: {"pill_sheet_id": activedPillSheet.id});

          if (activedPillSheet.todayPillIsAlreadyTaken) {
            showInvalidAlreadyTakenPillDialog(context);
          } else {
            showRecordPageRestDurationDialog(
              context,
              appearanceMode: appearanceMode,
              pillSheetGroup: pillSheetGroup,
              activedPillSheet: activedPillSheet,
              onDone: () async {
                analytics.logEvent(name: "done_rest_duration");
                removeAppBadge();

                Navigator.of(context).pop();
                await store.asyncAction.beginRestDuration(
                  pillSheetGroup: pillSheetGroup,
                  activedPillSheet: activedPillSheet,
                );

                didBeginRestDuration();
              },
            );
          }
        },
      ),
    );
  }
}
