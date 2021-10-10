import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/domain/record/components/pill_sheet/components/record_page_rest_duration_dialog.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/pill_sheet_group.dart';

class RecordPagePillOption extends StatelessWidget {
  final RecordPageStore store;
  final PillSheetGroup pillSheetGroup;
  final PillSheet? focusedPillSheet;

  const RecordPagePillOption({
    Key? key,
    required this.store,
    required this.pillSheetGroup,
    required this.focusedPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusedPillSheet = this.focusedPillSheet;
    final RestDuration? restDuration = focusedPillSheet?.activeRestDuration;

    if (focusedPillSheet == null ||
        focusedPillSheet.pillSheetType.isNotExistsNotTakenDuration) {
      // extract from dev tool
      return Container(height: 48);
    }

    return Container(
      width: PillSheetViewLayout.width,
      child: Row(children: [
        Spacer(),
        SizedBox(
          width: 80,
          child: PrimaryOutlinedButton(
            text: restDuration == null ? "休薬する" : "休薬終了",
            fontSize: 12,
            onPressed: () async {
              if (restDuration == null) {
                showRecordPageRestDurationDialog(context, () async {
                  Navigator.of(context).pop();
                  await store.beginResting(
                    pillSheetGroup: pillSheetGroup,
                    focusedPillSheet: focusedPillSheet,
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
                  focusedPillSheet: focusedPillSheet,
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
