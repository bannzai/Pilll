import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';
import 'package:pilll/entity/weekday.dart';

abstract class PillSheetModifiedHistoryTakenActionLayoutWidths {
  static final double leading = 150;
  static final double trailing = 150;
  static final double takenTime = 53;
  static final double takenMark = 61;
  static final double actionDescription = 100;
}

class PillSheetModifiedHistoryDate extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final String effectivePillNumber;

  const PillSheetModifiedHistoryDate({
    Key? key,
    required this.estimatedEventCausingDate,
    required this.effectivePillNumber,
  }) : super(key: key);

  int get _day => estimatedEventCausingDate.day;
  Weekday get _weekday =>
      WeekdayFunctions.weekdayFromDate(estimatedEventCausingDate);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: PillSheetModifiedHistoryTakenActionLayoutWidths.leading,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "$_day",
                  style: TextStyle(
                    color: TextColor.main,
                    fontFamily: FontFamily.number,
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  "(${_weekday.weekdayString()})",
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
          SizedBox(width: 16),
          Container(
            height: 26,
            child: VerticalDivider(
              color: PilllColors.divider,
              width: 0.5,
            ),
          ),
          SizedBox(width: 16),
          Container(
            width: 50,
            child: Text(
              "$effectivePillNumber",
              style: TextStyle(
                color: TextColor.main,
                fontFamily: FontFamily.japanese,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

extension PillSheetModifiedHistoryDateEffectivePillNumber
    on PillSheetModifiedHistoryDate {
  static String hyphen() => "-";
  static String taken(TakenPillValue value) {
    final before = value.beforeLastTakenPillNumber;
    final after = value.afterLastTakenPillNumber;
    if (before == after) {
      return "$before";
    }
    return "$before-$after";
  }

  static String revert(RevertTakenPillValue value) {
    final before = value.beforeLastTakenPillNumber;
    final after = value.afterLastTakenPillNumber;
    if (before == after) {
      return "$before";
    }
    return "$before-$after";
  }

  static String changed(ChangedPillNumberValue value) =>
      "${value.beforeLastTakenPillNumber}→${value.afterLastTakenPillNumber}";
}
