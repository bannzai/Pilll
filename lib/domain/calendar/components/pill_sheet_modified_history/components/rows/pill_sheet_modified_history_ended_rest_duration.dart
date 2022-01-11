import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/core/effective_pill_number.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/core/row_layout.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_date_component.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';

class PillSheetModifiedHistoryEndedRestDuration extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final EndedRestDurationValue? value;

  const PillSheetModifiedHistoryEndedRestDuration({
    Key? key,
    required this.estimatedEventCausingDate,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value == null) {
      return Container();
    }
    return Container(
      child: RowLayout(
        day: Day(estimatedEventCausingDate: estimatedEventCausingDate),
        effectiveNumbers: EffectivePillNumber(
            effectivePillNumber:
                PillSheetModifiedHistoryDateEffectivePillNumber.hyphen()),
        time: Row(
          children: [
            Container(
              child: Row(
                children: [
                  Text(
                    "休薬終了",
                    style: TextStyle(
                      color: TextColor.main,
                      fontSize: 12,
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Spacer(),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
