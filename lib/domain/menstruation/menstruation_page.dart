import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/store/menstruation.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const double _horizontalPadding = 10;

class MenstruationPage extends HookWidget {
  @override
  Scaffold build(BuildContext context) {
    final store = useProvider(menstruationsStoreProvider);
    final state = useProvider(menstruationsStoreProvider.state);
    final ItemPositionsListener itemPositionsListener =
        ItemPositionsListener.create();
    itemPositionsListener.itemPositions.addListener(() {
      final index = itemPositionsListener.itemPositions.value.last.index;
      store.updateCurrentCalendarIndex(index);
    });
    final ItemScrollController itemScrollController = ItemScrollController();

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        actions: [
          AppBarTextActionButton(
              onPressed: () {
                store.updateCurrentCalendarIndex(state.todayCalendarIndex);
                itemScrollController.scrollTo(
                    index: state.todayCalendarIndex,
                    duration: Duration(milliseconds: 300));
              },
              text: "今日"),
        ],
        title: SizedBox(
          child: Text(
            state.displayMonth,
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
                  child: Column(
                    children: [
                      _WeekdayLine(),
                      Expanded(
                        child: ScrollablePositionedList.builder(
                          itemScrollController: itemScrollController,
                          initialScrollIndex: state.currentCalendarIndex,
                          physics: PageScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemPositionsListener: itemPositionsListener,
                          itemBuilder: (context, index) {
                            final data = state.calendarDataSource[index];
                            return _DateLine(
                                days: data,
                                onTap: (e) {
                                  print("e:$e");
                                });
                          },
                          itemCount: state.calendarDataSource.length,
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
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
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
          Weekday.values.length,
          (index) => Expanded(
                child: WeekdayBadge(
                  weekday: Weekday.values[index],
                ),
              )),
    );
  }
}

class _DateLine extends StatelessWidget {
  final List<DateTime> days;
  final Function(DateTime) onTap;

  const _DateLine({
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
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isToday ? PilllColors.secondary : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "${date.day}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isToday ? Colors.white : weekday.weekdayColor(),
                ).merge(FontType.gridElement),
              ),
            ),
          )),
    );
  }
}
