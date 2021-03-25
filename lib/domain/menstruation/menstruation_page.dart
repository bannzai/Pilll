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

const double _horizontalPadding = 10;

class MenstruationPage extends HookWidget {
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
                height: 65,
                color: PilllColors.white,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: _horizontalPadding, right: _horizontalPadding),
                  child: ListView.builder(
                    physics: PageScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return _WeekdayLine(
                          begin: today(),
                          onTap: (e) {
                            print(e);
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<List<DateTime>> _dataSource() {
    final base = today();
    var begin = base.subtract(Duration(days: 180));
    final beginWeekdayOffset =
        WeekdayFunctions.weekdayFromDate(begin).index - Weekday.Sunday.index;
    begin = begin.subtract(Duration(days: beginWeekdayOffset));

    var end = base.add(Duration(days: 180));
    final endWeekdayOffset =
        WeekdayFunctions.weekdayFromDate(end).index - Weekday.Saturday.index;
    end = end.subtract(Duration(days: endWeekdayOffset));

    final diffDay = DateTimeRange(start: begin, end: end).duration.inDays;
    List<DateTime> days = [];
    for (int i = 0; i < diffDay; i++) {
      days.add(begin.add(Duration(days: i + 1)));
    }
    final line = (diffDay / Weekday.values.length).round();
    List<List<DateTime>> weekdayLine = [];
    for (int i = 0; i < line; i++) {
      final slice =
          days.sublist(i * Weekday.values.length, Weekday.values.length);
      weekdayLine.add(slice);
    }
    return List.generate(line,
        (i) => days.sublist(i * Weekday.values.length, Weekday.values.length));
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
          width: (MediaQuery.of(context).size.width - _horizontalPadding * 2) /
              Weekday.values.length,
          height: 40,
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
