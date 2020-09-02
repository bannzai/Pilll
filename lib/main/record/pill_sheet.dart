import 'package:Pilll/theme/color.dart';
import 'package:Pilll/model/weekday.dart';
import 'package:Pilll/main/record/pill_mark.dart';
import 'package:Pilll/main/record/weekday_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef PillMarkSelected = void Function(int);

class PillSheet extends StatelessWidget {
  final bool isHideWeekdayLine;

  const PillSheet({Key key, this.isHideWeekdayLine}) : super(key: key);
  int _calcIndex(int row, int line) {
    return row + 1 + (line) * 7;
  }

  Widget _weekdayLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        return WeekdayBadge(weekday: Weekday.values[index]);
      }),
    );
  }

  Widget _pillMarkWithNumber(int number) {
    return Column(
      children: <Widget>[
        Text("$number", style: TextStyle(color: PilllColors.weekday)),
        PillMark(number: number),
      ],
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
      width: 316,
      height: 264,
      decoration: BoxDecoration(
        color: PilllColors.pillSheet,
        borderRadius: BorderRadius.circular(10),
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
