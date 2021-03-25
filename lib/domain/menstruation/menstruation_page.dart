import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const double _horizontalPadding = 10;

class MenstruationPage extends HookWidget {
  @override
  Scaffold build(BuildContext context) {
    final dataSource = useMemoized(() => _dataSource());
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
                  child: ScrollablePositionedList.builder(
                    initialScrollIndex: dataSource.length ~/ 2,
                    physics: PageScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final data = dataSource[index];
                      return _WeekdayLine(
                          days: data,
                          onTap: (e) {
                            print("e:$e");
                          });
                    },
                    itemCount: dataSource.length,
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
    final beginWeekdayOffset = WeekdayFunctions.weekdayFromDate(begin).index;
    begin = begin.subtract(Duration(days: beginWeekdayOffset));

    var end = base.add(Duration(days: 180));
    final endWeekdayOffset =
        Weekday.values.last.index - WeekdayFunctions.weekdayFromDate(end).index;
    end = end.add(Duration(days: endWeekdayOffset));

    final diffDay = DateTimeRange(start: begin, end: end).duration.inDays;
    List<DateTime> days = [];
    for (int i = 0; i < diffDay + 1; i++) {
      days.add(begin.add(Duration(days: i)));
    }
    return List.generate(
        (diffDay / Weekday.values.length).round(),
        (i) => days.sublist(i * Weekday.values.length,
            i * Weekday.values.length + Weekday.values.length));
  }
}

class _WeekdayLine extends StatelessWidget {
  final List<DateTime> days;
  final Function(DateTime) onTap;

  const _WeekdayLine({
    Key? key,
    required this.days,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: days
          .map((e) => _Tile(
              date: e,
              isToday: isSameDay(today(), e),
              weekday: WeekdayFunctions.weekdayFromDate(e),
              onTap: onTap))
          .toList(),
    );
  }
}

class _Tile extends StatelessWidget {
  final DateTime date;
  final bool isToday;
  final Weekday weekday;
  final Function(DateTime) onTap;

  const _Tile({
    Key? key,
    required this.date,
    required this.isToday,
    required this.weekday,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(date),
      child: Container(
          width: (MediaQuery.of(context).size.width - _horizontalPadding * 2) /
              Weekday.values.length,
          height: 40,
          child: Text(
            "${date.day}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: weekday.weekdayColor(),
            ).merge(FontType.gridElement),
          )),
    );
  }
}
