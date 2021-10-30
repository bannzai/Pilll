import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_date_component.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';

class PillSheetModifiedHistoryBeganRestDuration extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final BeganRestDurationValue? value;

  const PillSheetModifiedHistoryBeganRestDuration({
    Key? key,
    required this.value,
    required this.estimatedEventCausingDate,
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
          children: [
            PillSheetModifiedHistoryDate(
                estimatedEventCausingDate: estimatedEventCausingDate,
                effectivePillNumber:
                    PillSheetModifiedHistoryDateEffectivePillNumber.hyphen()),
            Spacer(),
            Container(
              width: PillSheetModifiedHistoryTakenActionLayoutWidths.trailing,
              child: Row(
                children: [
                  Container(
                    child: Text(
                      "休薬開始",
                      style: TextStyle(
                        color: TextColor.main,
                        fontSize: 12,
                        fontFamily: FontFamily.japanese,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
