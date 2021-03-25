import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class MenstruationPage extends StatefulWidget {
  @override
  MenstruationPageState createState() => MenstruationPageState();
}

class MenstruationPageState extends State<MenstruationPage> {
  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        actions: [
          AppBarTextActionButton(onPressed: () {}, text: "今日"),
        ],
        title: SizedBox(
          child: Text(
            DateTimeFormatter.jaMonth(today()),
            style: TextStyle(color: TextColor.black),
          ),
        ),
        backgroundColor: PilllColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 62,
                color: PilllColors.white,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, int) {
                    return _WeekdayLine(
                        begin: today(),
                        onTap: (e) {
                          print(e);
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekdayLine extends StatelessWidget {
  final DateTime begin;
  final Function(Weekday) onTap;

  const _WeekdayLine({
    Key? key,
    required this.begin,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: Weekday.values
          .map((e) => begin.add(Duration(days: e.index)))
          .map((e) => _Tile(
              day: e.day,
              isToday: isSameDay(today(), e),
              weekday: WeekdayFunctions.weekdayFromDate(e),
              onTap: onTap))
          .toList(),
    );
  }
}

class _Tile extends StatelessWidget {
  final int day;
  final bool isToday;
  final Weekday weekday;
  final Function(Weekday) onTap;

  const _Tile({
    Key? key,
    required this.day,
    required this.isToday,
    required this.weekday,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(weekday),
      child: Container(
          child: Text(
        "$day",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: weekday.weekdayColor(),
        ).merge(FontType.gridElement),
      )),
    );
  }
}
