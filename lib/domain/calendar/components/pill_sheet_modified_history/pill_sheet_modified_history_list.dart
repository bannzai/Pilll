import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class CalendarPillSheetModifiedHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalendarPillSheetModifiedHistoryTakenPillActionRow(),
        CalendarPillSheetModifiedHistoryTakenPillActionRow(),
        CalendarPillSheetModifiedHistoryTakenPillActionRow(),
      ],
    );
  }
}

class CalendarPillSheetModifiedHistoryTakenPillActionRow
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(color: TextColor.main),
                children: [
                  TextSpan(
                    text: "22番",
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
            Spacer(),
            Text(
              "19:20",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: TextColor.main,
                fontSize: 15,
                fontFamily: FontFamily.number,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            LimitedBox(
              maxWidth: 60,
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

class CalendarPillSheetModifiedHistoryMonthHeader extends StatelessWidget {
  final DateTime dateTimeOfMonth;

  const CalendarPillSheetModifiedHistoryMonthHeader(
      {Key? key, required this.dateTimeOfMonth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(DateTimeFormatter.jaMonth(dateTimeOfMonth));
  }
}
