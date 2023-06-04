import 'package:flutter/material.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_line.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark_with_number_layout.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_view_layout.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';

class SettingPillSheetView extends StatelessWidget {
  final int pageIndex;
  final PillSheetAppearanceMode appearanceMode;
  final List<PillSheetType> pillSheetTypes;
  final int? selectedPillNumberIntoPillSheet;
  final Function(int pageIndex, int pillNumberIntoPillSheet) markSelected;

  PillSheetType get pillSheetType => pillSheetTypes[pageIndex];

  const SettingPillSheetView({
    Key? key,
    required this.pageIndex,
    required this.pillSheetTypes,
    required this.appearanceMode,
    required this.selectedPillNumberIntoPillSheet,
    required this.markSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PillSheetViewLayout(
      weekdayLines: null,
      pillMarkLines: List.generate(
        pillSheetType.numberOfLineInPillSheet,
        (index) {
          return PillMarkLine(pillMarks: _pillMarks(context, lineIndex: index));
        },
      ),
    );
  }

  List<Widget> _pillMarks(
    BuildContext context, {
    required int lineIndex,
  }) {
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

      final pillNumberIntoPillSheet = PillMarkWithNumberLayoutHelper.calcOriginalPillNumberIntoPillSheet(index, lineIndex);
      final offset = summarizedPillCountWithPillSheetTypesToEndIndex(pillSheetTypes: pillSheetTypes, endIndex: pageIndex);

      return SizedBox(
        width: PillSheetViewLayout.componentWidth,
        child: PillMarkWithNumberLayout(
          textOfPillNumber: Text(
            () {
              if (appearanceMode == PillSheetAppearanceMode.sequential) {
                return "${offset + pillNumberIntoPillSheet}";
              } else {
                return "$pillNumberIntoPillSheet";
              }
            }(),
            style: const TextStyle(color: PilllColors.weekday),
            textScaleFactor: 1,
          ),
          pillMark: PillMark(
            showsRippleAnimation: false,
            showsCheckmark: false,
            pillMarkType: _pillMarkTypeFor(
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
            ),
          ),
          onTap: () {
            analytics.logEvent(name: "setting_pill_mark_tapped", parameters: {
              "number": pillNumberIntoPillSheet,
              "page": pageIndex,
            });
            markSelected(pageIndex, pillNumberIntoPillSheet);
          },
        ),
      );
    });
  }

  PillMarkType _pillMarkTypeFor({
    required int pillNumberIntoPillSheet,
  }) {
    if (selectedPillNumberIntoPillSheet == pillNumberIntoPillSheet) {
      return PillMarkType.selected;
    }

    if (pillSheetType.dosingPeriod < pillNumberIntoPillSheet) {
      return (pillSheetType == PillSheetType.pillsheet_21 || pillSheetType == PillSheetType.pillsheet_24_rest_4)
          ? PillMarkType.rest
          : PillMarkType.fake;
    }
    return PillMarkType.normal;
  }
}
