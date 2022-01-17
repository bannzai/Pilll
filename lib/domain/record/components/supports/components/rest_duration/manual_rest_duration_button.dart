import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/domain/record/components/pill_sheet/components/record_page_rest_duration_dialog.dart';
import 'package:pilll/domain/record/components/supports/components/rest_duration/invalid_already_taken_pill_dialog.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';

class ManualRestDurationButton extends StatelessWidget {
  const ManualRestDurationButton({
    Key? key,
    required this.restDuration,
    required this.activedPillSheet,
    required this.store,
    required this.pillSheetGroup,
  }) : super(key: key);

  final RestDuration? restDuration;
  final PillSheet activedPillSheet;
  final RecordPageStore store;
  final PillSheetGroup pillSheetGroup;

  @override
  Widget build(BuildContext context) {
    final restDuration = this.restDuration;

    return SizedBox(
      width: 80,
      child: SmallAppOutlinedButton(
        text: restDuration == null ? "休薬する" : "休薬終了",
        onPressed: () async {
          analytics.logEvent(
              name: "manual_rest_duration_pressed",
              parameters: {"is_begin": restDuration == null});
          if (restDuration == null) {
            if (activedPillSheet.todayPillIsAlreadyTaken) {
              showInvalidAlreadyTakenPillDialog(context);
            } else {
              showRecordPageRestDurationDialog(context, () async {
                analytics.logEvent(name: "done_rest_duration");
                Navigator.of(context).pop();
                await store.beginResting(
                  pillSheetGroup: pillSheetGroup,
                  activedPillSheet: activedPillSheet,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(
                      seconds: 2,
                    ),
                    content: Text("休薬期間が始まりました"),
                  ),
                );
              });
            }
          } else {
            await store.endResting(
              pillSheetGroup: pillSheetGroup,
              activedPillSheet: activedPillSheet,
              restDuration: restDuration,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(
                  seconds: 2,
                ),
                content: Text("休薬期間が終了しました"),
              ),
            );
          }
        },
      ),
    );
  }
}
