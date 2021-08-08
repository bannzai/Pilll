import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_action_layout.dart';

class PillSheetModifiedHistoryAutomaticallyRecordedLastTakenDateAction
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LimitedBox(
              maxWidth:
                  PillSheetModifiedHistoryTakenActionLayoutWidths
                      .leading,
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: TextColor.main),
                      children: [
                        TextSpan(
                          text: "22",
                          style: TextStyle(
                            fontFamily: FontFamily.number,
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "(木)",
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
                    "22番",
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
            Spacer(),
            Container(
              constraints: BoxConstraints(
                maxWidth:
                    PillSheetModifiedHistoryTakenActionLayoutWidths
                        .takenTime,
              ),
              padding: EdgeInsets.only(left: 8),
              child: Text(
                "  -  ",
                style: TextStyle(
                  color: TextColor.main,
                  fontSize: 15,
                  fontFamily: FontFamily.number,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(flex: 2),
            Container(
              constraints: BoxConstraints(
                maxWidth:
                    PillSheetModifiedHistoryTakenActionLayoutWidths
                        .takenMark,
              ),
              padding: EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [SvgPicture.asset("images/o.svg")],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
