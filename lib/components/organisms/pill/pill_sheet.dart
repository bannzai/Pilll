import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/components/organisms/pill/pill_mark.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pilll/entity/pill_sheet_type.dart';

typedef PillMarkSelected = void Function(int);
typedef PillMarkTypeBuilder = PillMarkType Function(int);
typedef PillMarkTypeHasRippleAnimation = bool Function(int);
typedef DoneStateBuilder = bool Function(int);

class PillSheet extends StatelessWidget {
  static final double width = 316;
  static final double lineHeight = 49.5;
  static final double topSpace = 12;
  static final double bottomSpace = 24;
  final Weekday? firstWeekday;
  final PillSheetType pillSheetType;
  final PillMarkTypeBuilder pillMarkTypeBuilder;
  final DoneStateBuilder doneStateBuilder;
  final PillMarkTypeHasRippleAnimation? enabledMarkAnimation;
  final PillMarkSelected markSelected;

  bool get isHideWeekdayLine => firstWeekday == null;
  int get _numberOfLine => pillSheetType.numberOfLineInPillSheet;
  double get _height {
    final verticalSpacing = PillSheet.topSpace + PillSheet.bottomSpace;
    final pillMarkListHeight =
        PillSheet.lineHeight * _numberOfLine + verticalSpacing;
    return isHideWeekdayLine
        ? pillMarkListHeight
        : pillMarkListHeight + WeekdayBadgeConst.height;
  }

  const PillSheet({
    Key? key,
    this.firstWeekday,
    required this.pillSheetType,
    required this.pillMarkTypeBuilder,
    required this.enabledMarkAnimation,
    required this.markSelected,
    required this.doneStateBuilder,
  }) : super(key: key);

  int _calcIndex(int row, int line) {
    return row + 1 + (line) * 7;
  }

  Widget _weekdayLine() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: () {
          final firstWeekday = this.firstWeekday;
          if (firstWeekday == null) {
            return <Widget>[];
          }

          return WeekdayFunctions.weekdaysForFirstWeekday(firstWeekday)
              .map(
                (weekday) => WeekdayBadge(weekday: weekday),
              )
              .toList();
        }());
  }

  Widget _pillMarkWithNumber(int number) {
    var type = pillMarkTypeBuilder(number);
    return GestureDetector(
      onTap: () {
        markSelected(number);
      },
      child: Column(
        children: <Widget>[
          Text("$number",
              style: FontType.smallTitle
                  .merge(TextStyle(color: PilllColors.weekday))),
          PillMark(
            key: Key("PillMarkWidget_$number"),
            hasRippleAnimation: enabledMarkAnimation == null
                ? false
                : enabledMarkAnimation!(number),
            isDone: doneStateBuilder(number),
            type: type,
          ),
        ],
      ),
    );
  }

  Widget _pillMarkLine(int lineIndex) {
    final lineNumber = lineIndex + 1;
    int countOfPillMarksInLine = Weekday.values.length;
    if (lineNumber * Weekday.values.length > pillSheetType.totalCount) {
      int diff = pillSheetType.totalCount - lineIndex * Weekday.values.length;
      countOfPillMarksInLine = diff;
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(Weekday.values.length, (index) {
          if (index >= countOfPillMarksInLine) {
            return Container(width: PillMarkConst.edge);
          }
          return _pillMarkWithNumber(_calcIndex(index, lineIndex));
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: PillSheet.width,
      height: _height,
      decoration: BoxDecoration(
        color: PilllColors.pillSheet,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(28, 0, 28, PillSheet.bottomSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (!isHideWeekdayLine) _weekdayLine(),
            SizedBox(height: PillSheet.topSpace),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(_numberOfLine, (line) {
                    if (line + 1 == _numberOfLine) {
                      return [_pillMarkLine(line)];
                    }
                    return [
                      _pillMarkLine(line),
                      SvgPicture.asset("images/pill_sheet_dot_line.svg"),
                    ];
                  }).expand((element) => element).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
