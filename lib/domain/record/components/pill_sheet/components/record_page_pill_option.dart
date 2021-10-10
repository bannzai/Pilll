import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/util/datetime/day.dart';

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
    final RestDuration? restDuration;
    if (activedPillSheet.restDurations.isEmpty) {
      restDuration = null;
    } else {
      final restDurations = activedPillSheet.restDurations;
      if (restDurations.last.endDate == null &&
          restDurations.last.beginDate.isBefore(today())) {
        restDuration = restDurations.last;
      } else {
        restDuration = null;
      }
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
                await store.beginResting(
                  pillSheetGroup: pillSheetGroup,
                  activedPillSheet: activedPillSheet,
                );
              } else {
                await store.endResting(
                  pillSheetGroup: pillSheetGroup,
                  activedPillSheet: activedPillSheet,
                  restDuration: restDuration,
                );
              }
            },
          ),
        ),
      ]),
    );
  }
}
