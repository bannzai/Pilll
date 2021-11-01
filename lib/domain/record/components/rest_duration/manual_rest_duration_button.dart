import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/record/components/pill_sheet/components/record_page_rest_duration_dialog.dart';
import 'package:pilll/domain/record/components/rest_duration/invalid_already_taken_pill_dialog.dart';
import 'package:pilll/domain/record/components/rest_duration/invalid_insufficient_rest_duration_dialog.dart';
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
      child: PrimaryOutlinedButton(
        text: restDuration == null ? "休薬する" : "休薬終了",
        fontSize: 12,
        onPressed: () async {
          if (restDuration == null) {
            if (activedPillSheet.isAllTaken) {
              showInvalidAlreadyTakenPillDialog(context);
            } else if (activedPillSheet.todayPillNumber - 1 >
                activedPillSheet.lastTakenPillNumber) {
              showInvalidInsufficientRestDurationDialog(context);
            } else {
              showRecordPageRestDurationDialog(context, () async {
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
