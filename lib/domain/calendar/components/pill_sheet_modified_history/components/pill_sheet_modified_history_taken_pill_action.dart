import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_action_layout.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class PillSheetModifiedHistoryTakenPillAction extends StatelessWidget {
  final TakenPillValue? value;

  const PillSheetModifiedHistoryTakenPillAction({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value == null) {
      return Container();
    }
    final time = DateTimeFormatter.hourAndMinute(value.afterLastTakenDate);
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
                time,
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
