import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/components/page/discard_dialog.dart';
import 'package:pilll/domain/record/components/pill_sheet/components/record_page_rest_duration_dialog.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';

class RecordPagePillOption extends StatelessWidget {
  final RecordPageStore store;
  final PillSheetGroup pillSheetGroup;
  final PillSheet activedPillSheet;

  const RecordPagePillOption({
    Key? key,
    required this.store,
    required this.pillSheetGroup,
    required this.activedPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RestDuration? restDuration = activedPillSheet.activeRestDuration;

    return Container(
      width: PillSheetViewLayout.width,
      child: Row(children: [
        Spacer(),
        if (!pillSheetGroup.hasPillSheetRestDuration)
          SizedBox(
            width: 80,
            child: PrimaryOutlinedButton(
              text: restDuration == null ? "休薬する" : "休薬終了",
              fontSize: 12,
              onPressed: () async {
                if (!activedPillSheet.isAllTaken) {
                  showDiscardDialog(
                    context,
                    title: "未服用のピルがある場合\n休薬できません",
                    message:
                        "服用済みにしてから「休薬する」を押してください。前日以前から休薬したい場合は、「今日飲むピル番号」を調整してください。",
                    actions: [
                      SecondaryButton(
                        text: "閉じる",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                } else if (restDuration == null) {
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
          ),
      ]),
    );
  }
}
