import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/core/day.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/core/effective_pill_number.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';

abstract class PillSheetModifiedHistoryTakenActionLayoutWidths {
  static final double leading = 150;
  static final double trailing = 140;
  static final double takenTime = 60;
  static final double takenMark = 60;
}

class PillSheetModifiedHistoryDate extends StatelessWidget {
  final DateTime estimatedEventCausingDate;
  final String effectivePillNumber;

  const PillSheetModifiedHistoryDate({
    Key? key,
    required this.estimatedEventCausingDate,
    required this.effectivePillNumber,
  }) : super(key: key);

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
            child: Day(
              estimatedEventCausingDate: estimatedEventCausingDate,
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
            width: 53,
            child:
                EffectivePillNumber(effectivePillNumber: effectivePillNumber),
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
    if (before == (after - 1)) {
      return "$after番";
    }
    return "${before + 1}-$after番";
  }

  static String autoTaken(AutomaticallyRecordedLastTakenDateValue value) {
    final before = value.beforeLastTakenPillNumber;
    final after = value.afterLastTakenPillNumber;
    if (before == (after - 1)) {
      return "$after番";
    }
    return "${before + 1}-$after番";
  }

  static String revert(RevertTakenPillValue value) {
    return "${value.beforeLastTakenPillNumber}番";
  }

  static String changed(ChangedPillNumberValue value) =>
      "${value.beforeTodayPillNumber}→${value.afterTodayPillNumber}番";

  static String pillSheetCount(List<String> pillSheetIDs) =>
      pillSheetIDs.isNotEmpty ? "${pillSheetIDs.length}枚" : hyphen();
}
