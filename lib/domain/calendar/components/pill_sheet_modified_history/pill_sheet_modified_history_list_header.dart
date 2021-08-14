import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_date_component.dart';

class PillSheetModifiedHisotiryListHeader extends StatelessWidget {
  const PillSheetModifiedHisotiryListHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: PillSheetModifiedHistoryTakenActionLayoutWidths.leading,
          ),
          Container(
            width: PillSheetModifiedHistoryTakenActionLayoutWidths.takenMark,
            child: Text(
              "服用時間",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth:
                  PillSheetModifiedHistoryTakenActionLayoutWidths.takenMark,
            ),
            child: Text(
              "服用済み",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
