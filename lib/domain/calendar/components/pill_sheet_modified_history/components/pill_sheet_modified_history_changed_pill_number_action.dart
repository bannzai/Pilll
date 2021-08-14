import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_date_component.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';

class PillSheetModifiedHistoryChangedPillNumberAction extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final ChangedPillNumberValue? value;

  const PillSheetModifiedHistoryChangedPillNumberAction({
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
            Spacer(),
            Container(
              width: PillSheetModifiedHistoryTakenActionLayoutWidths.trailing,
              child: Row(
                children: [
                  Container(
                    child: Text(
                      "ピル番号変更",
                      style: TextStyle(
                        color: TextColor.main,
                        fontSize: 14,
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
