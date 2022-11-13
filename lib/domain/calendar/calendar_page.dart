import 'package:async_value_group/async_value_group.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_provider.dart';
import 'package:pilll/components/organisms/calendar/day/calendar_day_tile.dart';
import 'package:pilll/components/organisms/calendar/week/utility.dart';
import 'package:pilll/database/diary.dart';
import 'package:pilll/database/schedule.dart';
import 'package:pilll/domain/calendar/calendar_page_index_state_notifier.dart';
import 'package:pilll/domain/calendar/calendar_page_state.codegen.dart';
import 'package:pilll/domain/calendar/components/title/calendar_page_title.dart';
import 'package:pilll/domain/calendar/components/month_calendar/month_calendar.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart';
import 'package:pilll/domain/calendar/calendar_page_state_notifier.dart';
import 'package:flutter/material.dart';
import 'package:pilll/domain/diary_post/diary_post_page.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';

const _calendarDataSourceLength = 24;
final _calendarDataSource =
    List.generate(_calendarDataSourceLength, (index) => (index + 1) - 12).map((e) => DateTime(today().year, today().month + e, 1)).toList();
final _todayCalendarPageIndex = _calendarDataSource.lastIndexWhere((element) => isSameMonth(element, today()));

class CalendarPage extends HookConsumerWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(calendarPageStateNotifierProvider.notifier);
    final state = ref.watch(calendarPageStateNotifierProvider);

    final page = useState(_todayCalendarPageIndex);
    final pageController = usePageController(initialPage: _todayCalendarPageIndex);
    pageController.addListener(() {
      final index = (pageController.page ?? pageController.initialPage).round();
      page.value = index;
    });

    useAutomaticKeepAlive(wantKeepAlive: true);

    final displayedMonth = _calendarDataSource[page.value];
    return AsyncValueGroup.group6(
      ref.watch(diariesStreamForMonthProvider(displayedMonth)),
      ref.watch(schedulesForDateProvider(displayedMonth)),
      ref.watch(premiumAndTrialProvider),
      ref.watch(calendarMenstruationBandListProvider),
      ref.watch(calendarScheduledMenstruationBandListProvider),
      ref.watch(calendarNextPillSheetBandListProvider),
    ).when(
      data: (data) => _CalendarPageBody(
        diaries: data.t1,
        schedules: data.t2,
        premiumAndTrial: data.t3,
        calendarMenstruationBandModels: data.t4,
        calendarScheduledMenstruationBandModels: data.t5,
        calendarNextPillSheetBandModels: data.t6,
        displayedMonth: displayedMonth,
        page: page.value,
        pageController: pageController,
      ),
      error: (error, _) => UniversalErrorPage(
        error: error,
        child: null,
        reload: () => ref.refresh(calendarPageStateProvider),
      ),
      loading: () => const ScaffoldIndicator(),
    );
  }
}

class _CalendarPageBody extends StatelessWidget {
  final List<Diary> diaries;
  final List<Schedule> schedules;
  final PremiumAndTrial premiumAndTrial;
  final List<CalendarMenstruationBandModel> calendarMenstruationBandModels;
  final List<CalendarScheduledMenstruationBandModel> calendarScheduledMenstruationBandModels;
  final List<CalendarNextPillSheetBandModel> calendarNextPillSheetBandModels;
  final DateTime displayedMonth;
  final int page;
  final PageController pageController;

  const _CalendarPageBody({
    Key? key,
    required this.diaries,
    required this.schedules,
    required this.premiumAndTrial,
    required this.calendarMenstruationBandModels,
    required this.calendarScheduledMenstruationBandModels,
    required this.calendarNextPillSheetBandModels,
    required this.displayedMonth,
    required this.page,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        padding: const EdgeInsets.only(right: 10, bottom: 32),
        child: FloatingActionButton(
          onPressed: () {
            analytics.logEvent(name: "calendar_fab_pressed");
            Navigator.of(context).push(DiaryPostPageRoute.route(today(), null));
          },
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: PilllColors.secondary,
        ),
      ),
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: CalendarPageTitle(
          displayedMonth: displayedMonth,
          page: page,
          pageController: pageController,
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
                children: List.generate(_calendarDataSourceLength, (index) {
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
                        dateForMonth: displayedMonth,
                        weekCalendarBuilder: (context, monthCalendarState, weekDateRange) {
                          return CalendarWeekLine(
                            dateRange: weekDateRange,
                            calendarMenstruationBandModels: state.calendarMenstruationBandModels,
                            calendarScheduledMenstruationBandModels: state.calendarScheduledMenstruationBandModels,
                            calendarNextPillSheetBandModels: state.calendarNextPillSheetBandModels,
                            horizontalPadding: 0,
                            day: (context, weekday, date) {
                              if (state.displayMonth.isPreviousMonth(date)) {
                                return CalendarDayTile.grayout(
                                  weekday: weekday,
                                  date: date,
                                );
                              }
                              return CalendarDayTile(
                                weekday: weekday,
                                date: date,
                                showsDiaryMark: isExistsPostedDiary(monthCalendarState.diaries, date),
                                showsScheduleMark: isExistsSchedule(monthCalendarState.schedules, date),
                                showsMenstruationMark: false,
                                onTap: (date) {
                                  analytics.logEvent(name: "did_select_day_tile_on_calendar_card");
                                  transitionWhenCalendarDayTapped(context,
                                      date: date, diaries: monthCalendarState.diaries, schedules: monthCalendarState.schedules);
                                },
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
                store: stateNotifier,
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
