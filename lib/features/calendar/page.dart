import 'package:async_value_group/async_value_group.dart';
import 'package:collection/collection.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/calendar/components/const.dart';
import 'package:pilll/features/record/weekday_badge.dart';
import 'package:pilll/provider/diary.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/utils/analytics.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_provider.dart';
import 'package:pilll/components/organisms/calendar/day/calendar_day_tile.dart';
import 'package:pilll/components/organisms/calendar/week/utility.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/features/calendar/components/title/calendar_page_title.dart';
import 'package:pilll/features/calendar/components/month_calendar/month_calendar.dart';
import 'package:pilll/components/organisms/calendar/week/week_calendar.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart';
import 'package:flutter/material.dart';
import 'package:pilll/features/diary_post/diary_post_page.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';

// NOTE: 数字に特に意味はないが、ユーザーが過去のカレンダーも見たいということで十分な枠をとっている。Pilllの開始が2018年なので、それより後のデータが見れるくらいで良い
const _calendarDataSourceLength = 120;
final _calendarDataSource = List.generate(_calendarDataSourceLength, (index) => (index + 1) - (_calendarDataSourceLength ~/ 2))
    .map((e) => DateTime(today().year, today().month + e, 1))
    .toList();
final _todayCalendarPageIndex = _calendarDataSource.lastIndexWhere((element) => isSameMonth(element, today()));

class CalendarPage extends HookConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = useState(_todayCalendarPageIndex);
    final pageController = usePageController(initialPage: _todayCalendarPageIndex);
    pageController.addListener(() {
      final index = (pageController.page ?? pageController.initialPage).round();
      page.value = index;
    });

    final displayedMonth = _calendarDataSource[page.value];
    return AsyncValueGroup.group6(
      ref.watch(
          pillSheetModifiedHistoriesWithLimitProvider(limit: CalendarPillSheetModifiedHistoryCardState.pillSheetModifiedHistoriesThreshold + 1)),
      ref.watch(userProvider),
      ref.watch(calendarMenstruationBandListProvider),
      ref.watch(calendarScheduledMenstruationBandListProvider),
      ref.watch(calendarNextPillSheetBandListProvider),
      ref.watch(diaryForTodayProvider),
    ).when(
      data: (data) => _CalendarPageBody(
        histories: data.$1,
        user: data.$2,
        calendarMenstruationBandModels: data.$3,
        calendarScheduledMenstruationBandModels: data.$4,
        calendarNextPillSheetBandModels: data.$5,
        todayDiary: data.$6,
        displayedMonth: displayedMonth,
        page: page,
        pageController: pageController,
      ),
      error: (error, _) => UniversalErrorPage(
        error: error,
        child: null,
        reload: () => ref.refresh(databaseProvider),
      ),
      loading: () => const ScaffoldIndicator(),
    );
  }
}

class _CalendarPageBody extends StatelessWidget {
  final List<PillSheetModifiedHistory> histories;
  final User user;
  final List<CalendarMenstruationBandModel> calendarMenstruationBandModels;
  final List<CalendarScheduledMenstruationBandModel> calendarScheduledMenstruationBandModels;
  final List<CalendarNextPillSheetBandModel> calendarNextPillSheetBandModels;
  final DateTime displayedMonth;
  final Diary? todayDiary;
  final ValueNotifier<int> page;
  final PageController pageController;

  const _CalendarPageBody({
    required this.histories,
    required this.user,
    required this.calendarMenstruationBandModels,
    required this.calendarScheduledMenstruationBandModels,
    required this.calendarNextPillSheetBandModels,
    required this.todayDiary,
    required this.displayedMonth,
    required this.page,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    const double shadowHeight = 2;
    const height =
        WeekdayBadgeConst.height + (CalendarConstants.tileHeight + CalendarConstants.dividerHeight) * CalendarConstants.maxLineCount + shadowHeight;

    return Scaffold(
      floatingActionButton: Container(
        padding: const EdgeInsets.only(right: 10, bottom: 32),
        child: FloatingActionButton(
          onPressed: () {
            analytics.logEvent(name: "calendar_fab_pressed");
            Navigator.of(context).push(DiaryPostPageRoute.route(today(), todayDiary));
          },
          backgroundColor: PilllColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
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
              height: height,
              child: PageView(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                physics: const PageScrollPhysics(),
                children: List.generate(_calendarDataSourceLength, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: PilllColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: PilllColors.shadow,
                          blurRadius: 6.0,
                          offset: const Offset(0, shadowHeight),
                        ),
                      ],
                    ),
                    height: height,
                    width: MediaQuery.of(context).size.width,
                    child: MonthCalendar(
                        dateForMonth: displayedMonth,
                        weekCalendarBuilder: (context, diaries, schedules, weekDateRange) {
                          return CalendarWeekLine(
                            dateRange: weekDateRange,
                            calendarMenstruationBandModels: calendarMenstruationBandModels,
                            calendarScheduledMenstruationBandModels: calendarScheduledMenstruationBandModels,
                            calendarNextPillSheetBandModels: calendarNextPillSheetBandModels,
                            horizontalPadding: 0,
                            day: (context, weekday, date) {
                              if (date.isPreviousMonth(displayedMonth)) {
                                return CalendarDayTile.grayout(
                                  weekday: weekday,
                                  date: date,
                                );
                              }
                              return CalendarDayTile(
                                weekday: weekday,
                                date: date,
                                diary: diaries.firstWhereOrNull((e) => isSameDay(e.date, date)),
                                schedule: schedules.firstWhereOrNull((e) => isSameDay(e.date, date)),
                                onTap: (date) {
                                  analytics.logEvent(name: "did_select_day_tile_on_calendar_card");
                                  transitionWhenCalendarDayTapped(context, date: date, diaries: diaries, schedules: schedules);
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
                histories: histories,
                user: user,
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
