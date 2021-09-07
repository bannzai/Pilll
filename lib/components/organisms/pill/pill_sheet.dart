import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/components/organisms/pill/pill_mark.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

typedef PillMarkSelected = void Function(int);
typedef PillMarkTypeBuilder = PillMarkType Function(int);
typedef PillMarkTypeHasRippleAnimation = bool Function(int);
typedef DoneStateBuilder = bool Function(int);
typedef PremiumPillMarkBuilder = PremiumPillMarkModel Function(int);

final double componentWidth = 37;

class PillSheetView extends StatelessWidget {
  static final double width = 316;
  static final double lineHeight = 49.5;
  static final double topSpace = 24;
  static final double bottomSpace = 24;
  final Weekday? firstWeekday;
  final PillSheetType pillSheetType;
  final PillMarkTypeBuilder pillMarkTypeBuilder;
  final DoneStateBuilder doneStateBuilder;
  final PillMarkTypeHasRippleAnimation? enabledMarkAnimation;
  final PillMarkSelected markSelected;
  final PremiumPillMarkBuilder? premiumMarkBuilder;

  bool get isHideWeekdayLine => firstWeekday == null;
  int get _numberOfLine => pillSheetType.numberOfLineInPillSheet;

  static double calcHeight(
      int numberOfLineInPillSheet, bool isHideWeekdayLine) {
    final verticalSpacing = PillSheetView.topSpace + PillSheetView.bottomSpace;
    final pillMarkListHeight =
        PillSheetView.lineHeight * numberOfLineInPillSheet + verticalSpacing;
    return isHideWeekdayLine
        ? pillMarkListHeight
        : pillMarkListHeight + WeekdayBadgeConst.height;
  }

  const PillSheetView({
    Key? key,
    this.firstWeekday,
    required this.pillSheetType,
    required this.pillMarkTypeBuilder,
    required this.enabledMarkAnimation,
    required this.markSelected,
    required this.doneStateBuilder,
    this.premiumMarkBuilder,
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
                (weekday) => Container(
                  width: componentWidth,
                  color: Colors.transparent,
                  child: Center(child: WeekdayBadge(weekday: weekday)),
                ),
              )
              .toList();
        }());
  }

  Widget _pillMarkWithNumber(int number) {
    var type = pillMarkTypeBuilder(number);
    final enabledMarkAnimation = this.enabledMarkAnimation;
    final premiumMarkBuilder = this.premiumMarkBuilder;
    PremiumPillMarkModel? premium;
    if (premiumMarkBuilder != null) {
      premium = premiumMarkBuilder(number);
    }
    return GestureDetector(
      onTap: () {
        markSelected(number);
      },
      child: Column(
        children: <Widget>[
          Text(
            premium == null
                ? "$number"
                : DateTimeFormatter.monthAndDay(premium.date),
            style: FontType.smallTitle.merge(_upperTextColor(premium, number)),
            textScaleFactor: 1,
          ),
          PillMark(
            key: Key("PillMarkWidget_$number"),
            hasRippleAnimation: enabledMarkAnimation == null
                ? false
                : enabledMarkAnimation(number),
            isDone: doneStateBuilder(number),
            pillSheetType: type,
            premium: premium,
          ),
        ],
      ),
    );
  }

  TextStyle _upperTextColor(PremiumPillMarkModel? premium, int pillMarkNumber) {
    if (premium == null) {
      return TextStyle(color: PilllColors.weekday);
    }
    final begin = premium.pillNumberForMenstruationBegin;
    final duration = premium.menstruationDuration;
    final menstruationNumbers = List.generate(duration, (index) {
      final number = (begin + index) % premium.maxPillNumber;
      return number == 0 ? premium.maxPillNumber : number;
    });
    return menstruationNumbers.contains(pillMarkNumber)
        ? TextStyle(color: PilllColors.primary)
        : TextStyle(color: PilllColors.weekday);
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
            return Container(width: componentWidth);
          }
          return Container(
              width: componentWidth,
              child: _pillMarkWithNumber(_calcIndex(index, lineIndex)));
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PillSheetView.calcHeight(_numberOfLine, isHideWeekdayLine),
      width: PillSheetView.width,
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
      child: Container(
        padding: EdgeInsets.fromLTRB(22, 0, 22, PillSheetView.bottomSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (!isHideWeekdayLine) _weekdayLine(),
            SizedBox(height: PillSheetView.topSpace),
            Column(
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
          ],
        ),
      ),
    );
  }
}
