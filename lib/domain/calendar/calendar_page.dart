import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/calendar/calendar_page_index_state_notifier.dart';
import 'package:pilll/domain/calendar/calendar_page_state.codegen.dart';
import 'package:pilll/domain/calendar/components/title/calendar_page_title.dart';
import 'package:pilll/domain/calendar/components/month_calendar/month_calendar.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart';
import 'package:pilll/domain/calendar/calendar_page_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/util/datetime/day.dart';

class CalendarPage extends HookConsumerWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(calendarPageStateNotifierProvider.notifier);
    final state = ref.watch(calendarPageStateNotifierProvider);
    final calendarPageIndexStateNotifier = ref.watch(calendarPageIndexStateNotifierProvider.notifier);

    useAutomaticKeepAlive(wantKeepAlive: true);

    final pageController = usePageController(initialPage: todayCalendarPageIndex);
    pageController.addListener(() {
      final index = (pageController.page ?? pageController.initialPage).round();
      calendarPageIndexStateNotifier.set(index);
    });

    return state.when(
      data: (state) => _CalendarPage(store: store, state: state, pageController: pageController),
      error: (error, _) => UniversalErrorPage(
        error: error,
        child: null,
        reload: () => ref.refresh(calendarPageStateProvider),
      ),
      loading: () => const ScaffoldIndicator(),
    );
  }
}

class _CalendarPage extends StatelessWidget {
  final CalendarPageStateNotifier store;
  final CalendarPageState state;
  final PageController pageController;

  const _CalendarPage({Key? key, required this.store, required this.state, required this.pageController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        padding: const EdgeInsets.only(right: 10, bottom: 32),
        child: FloatingActionButton(
          onPressed: () {
            analytics.logEvent(name: "calendar_fab_pressed");
            final date = today();
            transitionToDiaryPost(context, date, state.todayMonthCalendar.diaries);
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
                children: List.generate(calendarDataSourceLength, (index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: PilllColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: PilllColors.shadow,
                          blurRadius: 6.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    // minus value of `margin`. so, it is show shadow
                    height: 444 - 10,
                    width: MediaQuery.of(context).size.width,
                    child: MonthCalendar(
                        dateForMonth: state.displayMonth,
                        weekCalendarBuilder: (context, monthCalendarState, weekCalendarState) {
                          return CalendarWeekdayLine(
                            state: weekCalendarState,
                            calendarMenstruationBandModels: state.calendarMenstruationBandModels,
                            calendarScheduledMenstruationBandModels: state.calendarScheduledMenstruationBandModels,
                            calendarNextPillSheetBandModels: state.calendarNextPillSheetBandModels,
                            horizontalPadding: 0,
                            onTap: (weekCalendarState, date) {
                              analytics.logEvent(name: "did_select_day_tile_on_calendar_card");
                              transitionToDiaryPost(
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
                  state.pillSheetModifiedHistories,
                  isPremium: state.premiumAndTrial.isPremium,
                  isTrial: state.premiumAndTrial.isTrial,
                  trialDeadlineDate: state.premiumAndTrial.trialDeadlineDate,
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
