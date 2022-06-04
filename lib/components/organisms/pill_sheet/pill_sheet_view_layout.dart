import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

class PillSheetViewLayout extends StatelessWidget {
  static final double width = 316;
  static final double lineHeight = 49.5;
  static final double topSpace = 24;
  static final double bottomSpace = 24;
  static final double componentWidth = 37;

  static double calcHeight(
    int numberOfLineInPillSheet,
    bool isHideWeekdayLine,
  ) {
    final verticalSpacing =
        PillSheetViewLayout.topSpace + PillSheetViewLayout.bottomSpace;
    final pillMarkListHeight =
        PillSheetViewLayout.lineHeight * numberOfLineInPillSheet +
            verticalSpacing;
    return isHideWeekdayLine
        ? pillMarkListHeight
        : pillMarkListHeight + WeekdayBadgeConst.height;
  }

  static PillSheetType mostLargePillSheetType(
      List<PillSheetType> pillSheetTypes) {
    final copied = [...pillSheetTypes];
    copied.sort((a, b) => b.totalCount.compareTo(a.totalCount));
    return copied.first;
  }

  final Widget? weekdayLines;
  final List<Widget> pillMarkLines;

  const PillSheetViewLayout({
    Key? key,
    required this.weekdayLines,
    required this.pillMarkLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weekdayLines = this.weekdayLines;
    return Container(
      height: PillSheetViewLayout.calcHeight(
        pillMarkLines.length,
        weekdayLines == null,
      ),
      width: PillSheetViewLayout.width,
      decoration: BoxDecoration(
        color: PilllColors.pillSheet,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(22, 0, 22, PillSheetViewLayout.bottomSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (weekdayLines != null) weekdayLines,
          SizedBox(height: PillSheetViewLayout.topSpace),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: pillMarkLines
                .asMap()
                .map((index, pillMarkLine) {
                  if (index + 1 == pillMarkLines.length) {
                    return MapEntry(index, [pillMarkLine]);
                  }
                  return MapEntry(index, [
                    pillMarkLine,
                    SvgPicture.asset("images/pill_sheet_dot_line.svg"),
                  ]);
                })
                .entries
                .expand((element) => element.value)
                .toList(),
          ),
        ],
      ),
    );
  }
}
