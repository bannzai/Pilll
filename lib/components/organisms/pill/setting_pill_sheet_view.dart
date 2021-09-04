import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_line.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_with_number_layout.dart';
import 'package:pilll/components/organisms/pill/pill_sheet_view_layout.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/weekday.dart';

class SettingPillSheetView extends StatelessWidget {
  final PillSheetType pillSheetType;
  final int? selectedPillNumber;
  final Function(int) markSelected;

  const SettingPillSheetView({
    Key? key,
    required this.pillSheetType,
    required this.selectedPillNumber,
    required this.markSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PillSheetViewLayout(
      weekdayLines: null,
      pillMarkLines: List.generate(
        pillSheetType.numberOfLineInPillSheet,
        (index) {
          return PillMarkLine(pillMarks: _pillMarks(context, index));
        },
      ),
    );
  }

  List<Widget> _pillMarks(BuildContext context, int lineIndex) {
    final lineNumber = lineIndex + 1;
    int countOfPillMarksInLine = Weekday.values.length;
    if (lineNumber * Weekday.values.length > pillSheetType.totalCount) {
      int diff = pillSheetType.totalCount - lineIndex * Weekday.values.length;
      countOfPillMarksInLine = diff;
    }
    return List.generate(Weekday.values.length, (index) {
      if (index >= countOfPillMarksInLine) {
        return Container(width: PillSheetViewLayout.componentWidth);
      }
      final number = PillMarkWithNumberLayoutHelper.calcPillNumber(
        column: index,
        lineIndex: lineIndex,
      );
      return Container(
        width: PillSheetViewLayout.componentWidth,
        child: PillMarkWithNumberLayout(
          textOfPillNumber:
              Text("$number", style: TextStyle(color: PilllColors.weekday)),
          pillMark: PillMark(
            hasRippleAnimation: false,
            isDone: false,
            pillSheetType: _pillMarkTypeFor(number),
          ),
          onTap: () {
            analytics.logEvent(name: "setting_pill_mark_tapped", parameters: {
              "number": number,
            });
            markSelected(number);
          },
        ),
      );
    });
  }

  PillMarkType _pillMarkTypeFor(
    int number,
  ) {
    if (selectedPillNumber == number) {
      return PillMarkType.selected;
    }
    if (pillSheetType.dosingPeriod < number) {
      return pillSheetType == PillSheetType.pillsheet_21
          ? PillMarkType.rest
          : PillMarkType.fake;
    }
    return PillMarkType.normal;
  }
}
