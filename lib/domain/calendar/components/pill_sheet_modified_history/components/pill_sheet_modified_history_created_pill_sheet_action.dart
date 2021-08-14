import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_action_layout.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';

class PillSheetModifiedHistoryCreatePillSheetAction extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final CreatedPillSheetValue? value;

  const PillSheetModifiedHistoryCreatePillSheetAction({
    Key? key,
    required this.estimatedEventCausingDate,
    required this.value,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PillSheetModifiedHistoryDate(
              estimatedEventCausingDate: estimatedEventCausingDate,
              beforePillNumber: null,
              afterPillNumber: null,
            ),
            PillSheetModifiedHistoryTrailingTakenTimeAndTakenMark(
              left: Container(
                child: Text(
                  "ピルシート追加",
                  style: TextStyle(
                    color: TextColor.main,
                    fontSize: 14,
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              right: null,
            ),
          ],
        ),
      ),
    );
  }
}
