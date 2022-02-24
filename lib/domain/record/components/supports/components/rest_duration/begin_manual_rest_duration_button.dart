import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/domain/record/components/pill_sheet/components/record_page_rest_duration_dialog.dart';
import 'package:pilll/domain/record/components/supports/components/rest_duration/invalid_already_taken_pill_dialog.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/setting.dart';

class BeginManualRestDurationButton extends StatelessWidget {
  final PillSheetAppearanceMode appearanceMode;
  final PillSheet activedPillSheet;
  final PillSheetGroup pillSheetGroup;
  final RecordPageStore store;

  const BeginManualRestDurationButton({
    Key? key,
    required this.appearanceMode,
    required this.activedPillSheet,
    required this.pillSheetGroup,
    required this.store,
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
                FlutterAppBadger.removeBadge();

                Navigator.of(context).pop();
                await store.beginResting(
                  pillSheetGroup: pillSheetGroup,
                  activedPillSheet: activedPillSheet,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(
                      seconds: 2,
                    ),
                    content: Text("休薬期間が始まりました"),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
