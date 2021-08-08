import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/app_card.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_action_layout.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list.dart';

class CalendarPillSheetModifiedHistoryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Container(
        padding: EdgeInsets.only(left: 16, top: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "服用履歴",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamily.japanese,
                    fontSize: 20,
                    color: TextColor.main,
                  ),
                ),
                SizedBox(width: 8),
                PremiumBadge(),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "28日連続服用記録中👏",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width:
                        PillSheetModifiedHistoryTakenActionLayoutWidths.leading,
                  ),
                  Spacer(flex: 2),
                  Container(
                    width: PillSheetModifiedHistoryTakenActionLayoutWidths
                        .takenMark,
                    child: Text(
                      "服用時間",
                      style: TextStyle(
                        color: TextColor.main,
                        fontFamily: FontFamily.japanese,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(flex: 2),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: PillSheetModifiedHistoryTakenActionLayoutWidths
                          .takenMark,
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
            ),
            SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: CalendarPillSheetModifiedHistoryList(),
            ),
          ],
        ),
      ),
    );
  }
}
