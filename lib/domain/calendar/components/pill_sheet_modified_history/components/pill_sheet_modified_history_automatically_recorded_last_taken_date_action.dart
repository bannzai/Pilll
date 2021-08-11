import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_action_layout.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction
    extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final PillSheetType pillSheetType;
  final AutomaticallyRecordedLastTakenDateValue? value;

  const PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction({
    Key? key,
    required this.estimatedEventCausingDate,
    required this.value,
    required this.pillSheetType,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value == null) {
      return Container();
    }
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PillSheetModifiedHistoryDate(
              estimatedEventCausingDate: estimatedEventCausingDate,
              beforePillNumber: value.beforeLastTakenPillNumber,
              afterPillNumber: value.afterLastTakenPillNumber,
            ),
            Container(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                "${value.afterLastTakenPillNumber}番",
                style: TextStyle(
                  color: TextColor.main,
                  fontSize: 12,
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth:
                    PillSheetModifiedHistoryTakenActionLayoutWidths.takenMark,
              ),
              padding: EdgeInsets.only(left: 8),
              child: Text(
                pillSheetType.notTakenWord,
                style: TextStyle(
                  color: TextColor.main,
                  fontFamily: FontFamily.japanese,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
