import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/calendar.dart';
import 'package:pilll/domain/calendar/calendar_band_model.dart';
import 'package:pilll/domain/calendar/calendar_weekday_line.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/domain/calendar/utility.dart';
import 'package:pilll/domain/calendar/weekly_calendar_state.dart';
import 'package:pilll/domain/menstruation/menstruation_card.dart';
import 'package:pilll/domain/menstruation/menstruation_edit_page.dart';
import 'package:pilll/domain/menstruation/menstruation_history_card.dart';
import 'package:pilll/domain/menstruation/menstruation_select_modify_type_sheet.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/store/menstruation.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const double _horizontalPadding = 10;

abstract class MenstruationPageConst {
  static const double calendarHeaderDropShadowOffset = 2;
  static final double tileHeight =
      CalendarConstants.tileHeight + calendarHeaderDropShadowOffset;
  static final double calendarHeaderHeight =
      WeekdayBadgeConst.height + tileHeight;
}

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
                  children: [
                    _WeekdayLine(),
                    LimitedBox(
                      maxHeight: MenstruationPageConst.tileHeight,
                      child: ScrollablePositionedList.builder(
                        itemScrollController: itemScrollController,
                        initialScrollIndex: state.currentCalendarIndex,
                        physics: PageScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemPositionsListener: itemPositionsListener,
                        itemBuilder: (context, index) {
                          final days = state.calendarDataSource[index];
                          return Container(
                            width: MediaQuery.of(context).size.width -
                                _horizontalPadding * 2,
                            height: MenstruationPageConst.tileHeight,
                            child: CalendarWeekdayLine(
                              diaries: state.diaries,
                              calendarState: SinglelineWeeklyCalendarState(
                                  DateRange(days.first, days.last)),
                              bandModels: buildBandModels(state.latestPillSheet,
                                      state.setting, state.entities, 12)
                                  .where((element) => !(element
                                      is CalendarNextPillSheetBandModel))
                                  .toList(),
                              horizontalPadding: _horizontalPadding,
                              onTap: (weeklyCalendarState, date) {
                                analytics.logEvent(
                                    name:
                                        "did_select_day_tile_on_menstruation");
                                transitionToPostDiary(
                                    context, date, state.diaries);
                              },
                            ),
                          );
                        },
                        itemCount: state.calendarDataSource.length,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: PilllColors.background,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 16),
                    itemCount: store.cardCount,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final body = () {
                        switch (index) {
                          case 0:
                            final cardState = store.cardState();
                            if (cardState == null) {
                              return Container();
                            }
                            return MenstruationCard(cardState);
                          case 1:
                            final cardState = store.historyCardState();
                            if (cardState == null) {
                              return Container();
                            }
                            return MenstruationHistoryCard(state: cardState);
                        }
                      };

                      return Padding(
                          padding:
                              EdgeInsets.only(left: 16, right: 16, bottom: 24),
                          child: body());
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: PrimaryButton(
                  onPressed: () {
                    analytics.logEvent(name: "pressed_menstruation_record");
                    final latestMenstruation = state.latestMenstruation;
                    if (latestMenstruation != null &&
                        latestMenstruation.dateRange.inRange(today())) {
                      showMenstruationEditPageForUpdate(
                          context, latestMenstruation);
                      return;
                    }

                    showModalBottomSheet(
                      context: context,
                      builder: (_) => MenstruationSelectModifyTypeSheet(
                          onTap: (type) async {
                        switch (type) {
                          case MenstruationSelectModifyType.today:
                            analytics.logEvent(
                                name: "tapped_menstruation_record_today");
                            Navigator.of(context).pop();
                            final created = await store.recordFromToday();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text(
                                    "${DateTimeFormatter.monthAndDay(created.beginDate)}から生理開始で記録しました"),
                              ),
                            );
                            return;
                          case MenstruationSelectModifyType.yesterday:
                            analytics.logEvent(
                                name: "tapped_menstruation_record_yesterday");
                            Navigator.of(context).pop();
                            final created = await store.recordFromYesterday();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text(
                                    "${DateTimeFormatter.monthAndDay(created.beginDate)}から生理開始で記録しました"),
                              ),
                            );
                            return;
                          case MenstruationSelectModifyType.begin:
                            analytics.logEvent(
                                name: "tapped_menstruation_record_begin");
                            Navigator.of(context).pop();
                            return showMenstruationEditPageForCreate(context);
                        }
                      }),
                    );
                  },
                  text: state.buttonString,
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
          (index) =>
              Expanded(child: WeekdayBadge(weekday: Weekday.values[index]))),
    );
  }
}
