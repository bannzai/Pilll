import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

class RecordTakenInformation extends StatelessWidget {
  final DateTime today;
  final DateTime beginingTakenDate;
  final DateTime lastTakenDate;
  const RecordTakenInformation({
    Key key,
    @required this.today,
    @required this.beginingTakenDate,
    @required this.lastTakenDate,
  }) : super(key: key);

  String _formattedToday() {
    // TODO:
    return DateTimeFormatter.monthAndWeekday(this.today);
  }

  int _calcTodayPillNumber() {
    // TODO:
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 54),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _todayWidget(),
              SizedBox(width: 28),
              Container(
                height: 64,
                child: VerticalDivider(
                  width: 10,
                  color: PilllColors.divider,
                ),
              ),
              SizedBox(width: 28),
              _takenWidget(),
            ],
          ),
        ],
      ),
    );
  }

  Column _takenWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 20,
          width: 80,
          child: Center(
            child: Text("今日飲むピル",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    fontFamily: FontFamily.japanese)),
          ),
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(20)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: <Widget>[
            Text(
              "${_calcTodayPillNumber()}",
              style: TextStyle(
                fontFamily: FontFamily.number,
                fontWeight: FontWeight.normal,
                fontSize: 40,
              ),
            ),
            Text(
              "番",
              style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
            ),
          ],
        )
      ],
    );
  }

  Center _todayWidget() {
    return Center(
      child: Text(
        "${_formattedToday()}",
        style: TextStyle(
            fontFamily: FontFamily.number,
            fontWeight: FontWeight.normal,
            fontSize: 18),
      ),
    );
  }
}
