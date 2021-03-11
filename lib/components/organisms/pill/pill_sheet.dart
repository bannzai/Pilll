import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/components/organisms/pill/pill_mark.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef PillMarkSelected = void Function(int);
typedef PillMarkTypeBuilder = PillMarkType Function(int);
typedef PillMarkTypeHasRippleAnimation = bool Function(int);
typedef DoneStateBuilder = bool Function(int);

class PillSheet extends StatelessWidget {
  static Size size = Size(316, 264);
  final Weekday firstWeekday;
  final PillMarkTypeBuilder pillMarkTypeBuilder;
  final DoneStateBuilder doneStateBuilder;
  final PillMarkTypeHasRippleAnimation enabledMarkAnimation;
  final PillMarkSelected markSelected;

  bool get isHideWeekdayLine => firstWeekday == null;

  const PillSheet({
    Key key,
    this.firstWeekday,
    @required this.pillMarkTypeBuilder,
    @required this.enabledMarkAnimation,
    @required this.markSelected,
    @required this.doneStateBuilder,
  }) : super(key: key);

  int _calcIndex(int row, int line) {
    return row + 1 + (line) * 7;
  }

  Widget _weekdayLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: WeekdayFunctions.weekdaysForFirstWeekday(firstWeekday)
          .map(
            (weekday) => WeekdayBadge(weekday: weekday),
          )
          .toList(),
    );
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
                : enabledMarkAnimation(number),
            isDone: doneStateBuilder(number),
            type: type,
          ),
        ],
      ),
    );
  }

  Widget _pillMarkLine(int line) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          return _pillMarkWithNumber(_calcIndex(index, line));
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: PillSheet.size.width,
      height: PillSheet.size.height,
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
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 38,
            top: isHideWeekdayLine ? 64 : 84,
            child: SvgPicture.asset("images/pill_sheet_dot_line.svg"),
          ),
          Positioned(
            left: 38,
            top: isHideWeekdayLine ? 124 : 136,
            child: SvgPicture.asset("images/pill_sheet_dot_line.svg"),
          ),
          Positioned(
            left: 38,
            top: isHideWeekdayLine ? 188 : 190,
            child: SvgPicture.asset("images/pill_sheet_dot_line.svg"),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isHideWeekdayLine) _weekdayLine() else Container(),
                ...List.generate(4, (line) {
                  return _pillMarkLine(line);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
