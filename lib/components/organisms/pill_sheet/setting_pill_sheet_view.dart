import 'package:flutter/material.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
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
  final List<PillSheetTypeInfo> pillSheetTypeInfos;
  final int? selectedPillNumberIntoPillSheet;
  final Function(int pageIndex, int pillNumberInPillSheet) markSelected;

  PillSheetTypeInfo get pillSheetTypeInfo => pillSheetTypeInfos[pageIndex];

  const SettingPillSheetView({
    Key? key,
    required this.pageIndex,
    required this.pillSheetTypeInfos,
    required this.appearanceMode,
    required this.selectedPillNumberIntoPillSheet,
    required this.markSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PillSheetViewLayout(
      weekdayLines: null,
      pillMarkLines: List.generate(
        pillSheetTypeInfo.numberOfLineInPillSheet,
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
    if (lineNumber * Weekday.values.length > pillSheetTypeInfo.totalCount) {
      int diff = pillSheetTypeInfo.totalCount - lineIndex * Weekday.values.length;
      countOfPillMarksInLine = diff;
    }
    return List.generate(Weekday.values.length, (index) {
      if (index >= countOfPillMarksInLine) {
        return Container(width: PillSheetViewLayout.componentWidth);
      }

      final pillNumberInPillSheet = PillMarkWithNumberLayoutHelper.calcPillNumberIntoPillSheet(index, lineIndex);
      final offset = summarizedPillCountWithPillSheetTypesToIndex(pillSheetTypeInfos: pillSheetTypeInfos, toIndex: pageIndex);

      return SizedBox(
        width: PillSheetViewLayout.componentWidth,
        child: PillMarkWithNumberLayout(
          pillNumber: Text(
            () {
              if (appearanceMode == PillSheetAppearanceMode.sequential) {
                return "${offset + pillNumberInPillSheet}";
              } else {
                return "$pillNumberInPillSheet";
              }
            }(),
            style: const TextStyle(color: PilllColors.weekday),
            textScaleFactor: 1,
          ),
          pillMark: PillMark(
            showsRippleAnimation: false,
            showsCheckmark: false,
            pillMarkType: _pillMarkTypeFor(
              pillNumberInPillSheet: pillNumberInPillSheet,
            ),
          ),
          onTap: () {
            analytics.logEvent(name: "setting_pill_mark_tapped", parameters: {
              "number": pillNumberInPillSheet,
              "page": pageIndex,
            });
            markSelected(pageIndex, pillNumberInPillSheet);
          },
        ),
      );
    });
  }

  PillMarkType _pillMarkTypeFor({
    required int pillNumberInPillSheet,
  }) {
    if (selectedPillNumberIntoPillSheet == pillNumberInPillSheet) {
      return PillMarkType.selected;
    }

    if (pillSheetTypeInfo.dosingPeriod < pillNumberInPillSheet) {
      return (pillSheetTypeInfo.pillSheetType == PillSheetType.pillsheet_21 || pillSheetTypeInfo.pillSheetType == PillSheetType.pillsheet_24_rest_4)
          ? PillMarkType.rest
          : PillMarkType.fake;
    }
    return PillMarkType.normal;
  }
}
