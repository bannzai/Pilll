import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_action_layout.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class PillSheetModifiedHistoryTakenPillAction extends StatelessWidget {
  final DateTime takenDateTime;
  final List<int> takenPillNumbers;

  const PillSheetModifiedHistoryTakenPillAction({
    Key? key,
    required this.takenDateTime,
    required this.takenPillNumbers,
  }) : super(key: key);

  String get _time {
    return DateTimeFormatter.hourAndMinute(takenDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PillSheetModifiedHistoryDate(),
            Container(
              width: PillSheetModifiedHistoryTakenActionLayoutWidths.takenTime,
              child: Text(
                _time,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: TextColor.main,
                  fontSize: 15,
                  fontFamily: FontFamily.number,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              width: PillSheetModifiedHistoryTakenActionLayoutWidths.takenMark,
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
