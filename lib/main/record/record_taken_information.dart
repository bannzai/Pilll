import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
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
  })  : assert(today != null),
        super(key: key);

  String _formattedToday() => DateTimeFormatter.monthAndDay(this.today);

  String _todayWeekday() => DateTimeFormatter.weekday(this.today);

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
        Text(
          "💊 今日飲むピル",
          style: FontType.assisting.merge(TextColorStyle.noshime),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: <Widget>[
            Text("${_calcTodayPillNumber()}",
                style: FontType.xHugeNumber.merge(TextColorStyle.main)),
            SizedBox(width: 4),
            Text("番",
                style: FontType.assistingBold.merge(TextColorStyle.noshime)),
          ],
        )
      ],
    );
  }

  Center _todayWidget() {
    return Center(
      child: Text(
        "${_formattedToday()} (${_todayWeekday()})",
        style: TextStyle().merge(
          FontType.xBigNumber.merge(TextColorStyle.main),
        ),
      ),
    );
  }
}
