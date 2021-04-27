import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/calendar/calendar_card.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/calendar_help.dart';
import 'package:pilll/store/calendar_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'package:pilll/entity/diary.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  List<Diary> diaries = [];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final store = watch(calendarPageStateProvider);
      final state = watch(calendarPageStateProvider.state);
      diaries = state.diaries;
      final settingEntity = state.setting;
      if (state.shouldShowIndicator) {
        return ScaffoldIndicator();
      }
      final ItemScrollController itemScrollController = ItemScrollController();
      final ItemPositionsListener itemPositionsListener =
          ItemPositionsListener.create();
      itemPositionsListener.itemPositions.addListener(() {
        final index = itemPositionsListener.itemPositions.value.last.index;
        store.updateCurrentCalendarIndex(index);
      });
      return Scaffold(
        backgroundColor: PilllColors.background,
        appBar: AppBar(
          leading: AppBarTextActionButton(
              onPressed: () {
                analytics.logEvent(name: "calendar_to_today_pressed");
                store.updateCurrentCalendarIndex(state.todayCalendarIndex);
                itemScrollController.scrollTo(
                    index: state.todayCalendarIndex,
                    duration: Duration(milliseconds: 300));
              },
              text: "今日"),
          actions: [
            IconButton(
              icon: SvgPicture.asset("images/help.svg"),
              onPressed: () {
                analytics.logEvent(name: "pressed_calendar_help");
                showDialog(
                    context: context,
                    builder: (_) {
                      return CalendarHelpPage();
                    });
              },
            ),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: SvgPicture.asset("images/arrow_left.svg"),
                onPressed: () {
                  final previousMonthIndex = state.currentCalendarIndex - 1;
                  itemScrollController.scrollTo(
                      index: previousMonthIndex,
                      duration: Duration(milliseconds: 300));
                  store.updateCurrentCalendarIndex(previousMonthIndex);
                  analytics
                      .logEvent(name: "pressed_previous_month", parameters: {
                    "current_index": state.currentCalendarIndex,
                    "previous_index": previousMonthIndex
                  });
                },
              ),
              Text(
                state.displayMonth,
                style: TextColorStyle.main.merge(FontType.subTitle),
              ),
              IconButton(
                icon: SvgPicture.asset("images/arrow_right.svg"),
                onPressed: () {
                  final nextMonthIndex = state.currentCalendarIndex + 1;
                  itemScrollController.scrollTo(
                      index: nextMonthIndex,
                      duration: Duration(milliseconds: 300));
                  store.updateCurrentCalendarIndex(nextMonthIndex);
                  analytics.logEvent(name: "pressed_next_month", parameters: {
                    "current_index": state.currentCalendarIndex,
                    "next_index": nextMonthIndex
                  });
                },
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: PilllColors.white,
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 444,
                child: ScrollablePositionedList.builder(
                  itemScrollController: itemScrollController,
                  initialScrollIndex: state.currentCalendarIndex,
                  scrollDirection: Axis.horizontal,
                  physics: PageScrollPhysics(),
                  itemCount: state.calendarDataSource.length,
                  itemPositionsListener: itemPositionsListener,
                  itemBuilder: (context, index) {
                    final date = state.calendarDataSource[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 2),
                      decoration: BoxDecoration(
                        color: PilllColors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: PilllColors.shadow,
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      height: 444,
                      width: MediaQuery.of(context).size.width,
                      child: CalendarCard(
                        state: CalendarCardState(
                          date: date,
                          latestPillSheet: state.latestPillSheet,
                          setting: settingEntity,
                          diaries: state.diaries,
                          menstruations: state.menstruations,
                          bands: state.bands,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
