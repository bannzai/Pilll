import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/domain/calendar/calendar_weekday_line.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/domain/calendar/weekly_calendar_state.dart';
import 'package:pilll/domain/menstruation/menstruation_card.dart';
import 'package:pilll/domain/menstruation/menstruation_card_state.dart';
import 'package:pilll/domain/menstruation/menstruation_edit_page.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/store/menstruation.dart';
import 'package:pilll/store/pill_sheet.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const double _horizontalPadding = 10;

abstract class MenstruationPageConst {
  static final double calendarHeaderHeight =
      86 + calendarHeaderDropShadowOffset;
  static const double calendarHeaderDropShadowOffset = 2;
}

class MenstruationPage extends HookWidget {
  @override
  Scaffold build(BuildContext context) {
    final menstruationStore = useProvider(menstruationsStoreProvider);
    final menstruationState = useProvider(menstruationsStoreProvider.state);
    final pillSheetStore = useProvider(pillSheetStoreProvider);
    final pillSheetState = useProvider(pillSheetStoreProvider.state);
    final ItemPositionsListener itemPositionsListener =
        ItemPositionsListener.create();
    itemPositionsListener.itemPositions.addListener(() {
      final index = itemPositionsListener.itemPositions.value.last.index;
      menstruationStore.updateCurrentCalendarIndex(index);
    });
    final ItemScrollController itemScrollController = ItemScrollController();

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        actions: [
          AppBarTextActionButton(
              onPressed: () {
                menstruationStore.updateCurrentCalendarIndex(
                    menstruationState.todayCalendarIndex);
                itemScrollController.scrollTo(
                    index: menstruationState.todayCalendarIndex,
                    duration: Duration(milliseconds: 300));
              },
              text: "今日"),
        ],
        title: SizedBox(
          child: Text(
            menstruationState.displayMonth,
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
                padding: const EdgeInsets.only(
                  left: _horizontalPadding,
                  right: _horizontalPadding,
                ),
                margin: const EdgeInsets.only(
                  bottom: MenstruationPageConst.calendarHeaderDropShadowOffset,
                ),
                width: MediaQuery.of(context).size.width,
                height: MenstruationPageConst.calendarHeaderHeight,
                decoration: BoxDecoration(
                  color: PilllColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: PilllColors.shadow,
                      blurRadius: 4.0,
                      offset: Offset(0,
                          MenstruationPageConst.calendarHeaderDropShadowOffset),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _WeekdayLine(),
                    LimitedBox(
                      maxHeight: MenstruationPageConst.calendarHeaderHeight -
                          WeekdayBadgeConst.height,
                      child: ScrollablePositionedList.builder(
                        itemScrollController: itemScrollController,
                        initialScrollIndex:
                            menstruationState.currentCalendarIndex,
                        physics: PageScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemPositionsListener: itemPositionsListener,
                        itemBuilder: (context, index) {
                          final data =
                              menstruationState.calendarDataSource[index];
                          return _DateLine(
                              days: data,
                              diaries: menstruationState.diaries,
                              onTap: (e) {
                                print("e:$e");
                              });
                        },
                        itemCount: menstruationState.calendarDataSource.length,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: PilllColors.background,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 16),
                    itemCount: 1,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return MenstruationCard(
                        MenstruationCardState(
                            scheduleDate: today(), countdownString: "あと1日"),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: PrimaryButton(
                  onPressed: () {
                    final menstruation = menstruationState.entities.isEmpty
                        ? null
                        : menstruationState.entities.last;
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => MenstruationEditPage(
                        menstruation: menstruation,
                      ),
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                    );
                  },
                  text: "生理期間を編集",
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(Weekday.values.length, (index) {
        final weekday = Weekday.values[index];
        return Expanded(
          child: Container(
            child: Text(weekday.weekdayString(),
                textAlign: TextAlign.center,
                style: FontType.sSmallTitle
                    .merge(TextStyle(color: weekday.weekdayColor()))),
          ),
        );
      }),
    );
  }
}

class _DateLine extends StatelessWidget {
  final List<DateTime> days;
  final List<Diary> diaries;
  final Function(DateTime) onTap;

  const _DateLine({
    Key? key,
    required this.days,
    required this.diaries,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - _horizontalPadding * 2,
      height: CalendarConstants.tileHeight,
      child: CalendarWeekdayLine(
        diaries: diaries,
        calendarState:
            SinglelineWeeklyCalendarState(DateRange(days.first, days.last)),
        bandModels: [],
        horizontalPadding: _horizontalPadding,
        onTap: (weeklyCalendarState, date) =>
            transitionToPostDiary(context, date, diaries),
      ),
    );
  }
}
