import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_action_layout.dart';

class PillSheetModifiedHistoryRevertTakenPillAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LimitedBox(
              maxWidth: PillSheetModifiedHistoryTakenActionLayoutWidths.leading,
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: TextColor.main),
                      children: [
                        TextSpan(
                          text: "18",
                          style: TextStyle(
                            fontFamily: FontFamily.number,
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "(日)",
                          style: TextStyle(
                            fontFamily: FontFamily.japanese,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    height: 26,
                    child: VerticalDivider(
                      color: PilllColors.divider,
                      width: 0.5,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    "19番",
                    style: TextStyle(
                      color: TextColor.main,
                      fontFamily: FontFamily.japanese,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 2),
            Container(
              width: PillSheetModifiedHistoryTakenActionLayoutWidths
                  .actionDescription,
              child: Text(
                "服用取り消し",
                style: TextStyle(
                  color: TextColor.main,
                  fontSize: 14,
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              width: PillSheetModifiedHistoryTakenActionLayoutWidths.takenMark,
            ),
          ],
        ),
      ),
    );
  }
}
