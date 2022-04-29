import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/calendar/calendar_page_title.dart';
import 'package:pilll/domain/calendar/components/month/month_calendar.dart';
import 'package:pilll/components/organisms/calendar/weekly/weekly_calendar.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart';
import 'package:pilll/domain/home/home_page.dart';
import 'package:pilll/domain/calendar/calendar_page_store.dart';
import 'package:flutter/material.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/hooks/automatic_keep_alive_client_mixin.dart';
import 'package:pilll/util/datetime/day.dart';

class CalendarPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(calendarPageStateStoreProvider.notifier);
    final state = ref.watch(calendarPageStateStoreProvider);
    homeKey.currentState?.diaries = state.diariesForMonth;

    useAutomaticKeepAlive(wantKeepAlive: true);

    final exception = state.exception;
    if (exception != null) {
      return UniversalErrorPage(
        error: exception,
        child: null,
        reload: () => store.reset(),
      );
    }

    if (state.shouldShowIndicator) {
      return ScaffoldIndicator();
    }

    final pageController =
        usePageController(initialPage: state.currentCalendarIndex);
    pageController.addListener(() {
      final index = (pageController.page ?? pageController.initialPage).round();
      store.updateCurrentCalendarIndex(index);
    });

    return Scaffold(
      floatingActionButton: Container(
        padding: const EdgeInsets.only(right: 10, bottom: 32),
        child: FloatingActionButton(
          onPressed: () {
            analytics.logEvent(name: "calendar_fab_pressed");
            final date = today();
            transitionToPostDiary(context, date, diaries);
          },
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: PilllColors.secondary,
        ),
      ),
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: CalendarPageTitle(
          state: state,
          pageController: pageController,
          store: store,
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
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                physics: const PageScrollPhysics(),
                children:
                    List.generate(state.calendarDataSource.length, (index) {
                  return Container(
                    height: 444,
                    width: MediaQuery.of(context).size.width,
                    child: MonthCalendar(
                        dateForMonth: state.displayMonth,
                        weekCalendarBuilder:
                            (context, monthCalendarState, weekCalendarState) {
                          return CalendarWeekdayLine(
                            state: weekCalendarState,
                            horizontalPadding: 0,
                            onTap: (weeklyCalendarState, date) {
                              analytics.logEvent(
                                  name: "did_select_day_tile_on_calendar_card");
                              transitionToPostDiary(
                                context,
                                date,
                                monthCalendarState.diaries,
                              );
                            },
                          );
                        }),
                  );
                }),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: CalendarPillSheetModifiedHistoryCard(
                store: store,
                state: CalendarPillSheetModifiedHistoryCardState(
                  state.allPillSheetModifiedHistories,
                  isPremium: state.isPremium,
                  isTrial: state.isTrial,
                  trialDeadlineDate: state.trialDeadlineDate,
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
