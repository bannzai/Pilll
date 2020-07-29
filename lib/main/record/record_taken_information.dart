import 'package:Pilll/color.dart';
import 'package:Pilll/font.dart';
import 'package:flutter/material.dart';

class RecordTakenInformation extends StatelessWidget {
  final DateTime today;
  final DateTime beginingTakenDate;
  final DateTime lastTakenDate;
  const RecordTakenInformation({
    Key key,
    this.today,
    this.beginingTakenDate,
    this.lastTakenDate,
  }) : super(key: key);

  String _formattedToday() {
    // TODO:
    return "2020/07/22";
  }

  String _todayWeekday() {
    // TODO:
    return "火";
  }

  int _calcTodayPillNumber() {
    // TODO:
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 316,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                "${_formattedToday()} (${_todayWeekday()})",
                style: TextStyle(
                    fontFamily: PilllFontFamily.number,
                    fontWeight: FontWeight.normal,
                    fontSize: 18),
              ),
            ),
          ),
          Container(
            height: 64,
            child: VerticalDivider(
              width: 10,
              color: PilllColors.divider,
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  height: 20,
                  width: 80,
                  child: Center(
                    child: Text("今日飲むピル",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            fontFamily: PilllFontFamily.japanese)),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(20)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: <Widget>[
                    Text(
                      "${_calcTodayPillNumber()}",
                      style: TextStyle(
                        fontFamily: PilllFontFamily.number,
                        fontWeight: FontWeight.normal,
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      "番",
                      style: TextStyle(
                        fontFamily: PilllFontFamily.japanese,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
