import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/shadow_container.dart';
import 'package:pilll/components/organisms/calendar/monthly/monthly_calendar_layout.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/domain/menstruation/components/calendar/menstruation_single_line_state.dart';
import 'package:pilll/components/organisms/calendar/weekly/weekly_calendar.dart';
import 'package:pilll/domain/calendar/date_range.dart';
import 'package:pilll/components/organisms/calendar/utility.dart';
import 'package:pilll/domain/menstruation/menstruation_card.dart';
import 'package:pilll/domain/menstruation/menstruation_state.dart';
import 'package:pilll/domain/menstruation_edit/menstruation_edit_page.dart';
import 'package:pilll/domain/menstruation/menstruation_history_card.dart';
import 'package:pilll/domain/menstruation/menstruation_select_modify_type_sheet.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/domain/menstruation/menstruation_store.dart';
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
                analytics.logEvent(name: "menstruation_to_today_pressed");
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
          child: Stack(
            children: [
              Column(
                children: [
                  MenstruationCalendarHeader(
                      itemScrollController: itemScrollController,
                      state: state,
                      itemPositionsListener: itemPositionsListener),
                  Expanded(
                    child: MenstruationCardList(store: store),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: MenstruationRecordButton(state: state, store: store),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenstruationRecordButton extends StatelessWidget {
  const MenstruationRecordButton({
    Key? key,
    required this.state,
    required this.store,
  }) : super(key: key);

  final MenstruationState state;
  final MenstruationStore store;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: () {
        analytics.logEvent(name: "pressed_menstruation_record");
        final latestMenstruation = state.latestMenstruation;
        if (latestMenstruation != null &&
            latestMenstruation.dateRange.inRange(today())) {
          showMenstruationEditPageForUpdate(context, latestMenstruation);
          return;
        }

        final setting = state.setting;
        if (setting == null) {
          throw FormatException("生理記録前にデータの読み込みに失敗しました。再読み込みしてから再度お試しください");
        }

        if (setting.durationMenstruation == 0) {
          return showMenstruationEditPageForCreate(context);
        }
        showModalBottomSheet(
          context: context,
          builder: (_) =>
              MenstruationSelectModifyTypeSheet(onTap: (type) async {
            switch (type) {
              case MenstruationSelectModifyType.today:
                analytics.logEvent(name: "tapped_menstruation_record_today");
                Navigator.of(context).pop();
                final created = await store.recordFromToday();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
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
                    duration: Duration(seconds: 2),
                    content: Text(
                        "${DateTimeFormatter.monthAndDay(created.beginDate)}から生理開始で記録しました"),
                  ),
                );
                return;
              case MenstruationSelectModifyType.begin:
                analytics.logEvent(name: "tapped_menstruation_record_begin");
                Navigator.of(context).pop();
                return showMenstruationEditPageForCreate(context);
            }
          }),
        );
      },
      text: state.buttonString,
    );
  }
}

class MenstruationCardList extends StatelessWidget {
  const MenstruationCardList({
    Key? key,
    required this.store,
  }) : super(key: key);

  final MenstruationStore store;

  @override
  Widget build(BuildContext context) {
    final cardState = store.cardState();
    final historyCardState = store.historyCardState();
    return Container(
      color: PilllColors.background,
      child: ListView(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        scrollDirection: Axis.vertical,
        children: [
          if (cardState != null) ...[
            MenstruationCard(cardState),
            SizedBox(height: 24),
          ],
          if (historyCardState != null)
            MenstruationHistoryCard(state: historyCardState),
        ],
      ),
    );
  }
}

class MenstruationCalendarHeader extends StatelessWidget {
  const MenstruationCalendarHeader({
    Key? key,
    required this.itemScrollController,
    required this.state,
    required this.itemPositionsListener,
  }) : super(key: key);

  final ItemScrollController itemScrollController;
  final MenstruationState state;
  final ItemPositionsListener itemPositionsListener;

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Container(
        padding: const EdgeInsets.only(
          left: _horizontalPadding,
          right: _horizontalPadding,
        ),
        width: MediaQuery.of(context).size.width,
        height: MenstruationPageConst.calendarHeaderHeight,
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
                      calendarState: MenstruationSinglelineWeeklyCalendarState(
                        dateRange: DateRange(days.first, days.last),
                        diariesForMonth: state.diariesForMonth,
                        allBandModels: buildBandModels(state.latestPillSheet,
                                state.setting, state.entities, 12)
                            .where((element) =>
                                !(element is CalendarNextPillSheetBandModel))
                            .toList(),
                      ),
                      horizontalPadding: _horizontalPadding,
                      onTap: (weeklyCalendarState, date) {
                        analytics.logEvent(
                            name: "did_select_day_tile_on_menstruation");
                        transitionToPostDiary(
                            context, date, state.diariesForMonth);
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
