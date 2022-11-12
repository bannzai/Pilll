import 'package:async_value_group/async_value_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_provider.dart';
import 'package:pilll/database/diary.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/schedule.dart';
import 'package:pilll/domain/calendar/components/month_calendar/month_calendar.dart';
import 'package:pilll/domain/menstruation/components/calendar/menstruation_calendar_header.dart';
import 'package:pilll/domain/menstruation/components/menstruation_card_list.dart';
import 'package:pilll/domain/menstruation/components/menstruation_record_button.dart';
import 'package:pilll/domain/menstruation/menstruation_calendar_page_index_state_notifier.dart';
import 'package:pilll/domain/menstruation/menstruation_state.codegen.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/domain/menstruation/menstruation_page_state_notifier.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

abstract class MenstruationPageConst {
  static const double calendarHeaderDropShadowOffset = 2;
  static const double tileHeight = CalendarConstants.tileHeight + calendarHeaderDropShadowOffset;
  static const double calendarHeaderHeight = WeekdayBadgeConst.height + tileHeight;
}

class MenstruationPage extends HookConsumerWidget {
  const MenstruationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(menstruationPageStateNotifierProvider.notifier);
    final state = ref.watch(menstruationPageStateNotifierProvider);
    final calendarPageIndexStateNotifier = ref.watch(menstruationCalendarPageIndexStateNotifierProvider.notifier);
    useAutomaticKeepAlive(wantKeepAlive: true);

    final pageController = usePageController(initialPage: todayCalendarPageIndex);
    pageController.addListener(() {
      final index = (pageController.page ?? pageController.initialPage).round();

      calendarPageIndexStateNotifier.set(index);
    });

    AsyncValueGroup.group9(
      ref.watch(latestPillSheetGroupStreamProvider),
      ref.watch(premiumAndTrialProvider),
      ref.watch(settingProvider),
      ref.watch(diariesStream90Days(today())),
      ref.watch(allMenstruationStreamProvider),
      ref.watch(schedules90Days(today())),
      ref.watch(calendarMenstruationBandListProvider),
      ref.watch(calendarScheduledMenstruationBandListProvider),
      ref.watch(calendarNextPillSheetBandListProvider),
    ).when(
      data: (data) {},
      error: (error, _) => UniversalErrorPage(
        error: error,
        child: null,
        reload: () => ref.refresh(menstruationPageStateProvider),
      ),
      loading: () => const ScaffoldIndicator(),
    );

    return state.when(
      data: (state) => MenstruationPageBody(store: store, state: state, pageController: pageController),
      error: (error, _) => UniversalErrorPage(
        error: error,
        child: null,
        reload: () => ref.refresh(menstruationPageStateProvider),
      ),
      loading: () => const ScaffoldIndicator(),
    );
  }
}

class MenstruationPageBody extends StatelessWidget {
  final MenstruationPageStateNotifier store;
  final MenstruationState state;
  final PageController pageController;
  final List<CalendarMenstruationBandModel> calendarMenstruationBandModels;
  final List<CalendarScheduledMenstruationBandModel> calendarScheduledMenstruationBandModels;
  final List<CalendarNextPillSheetBandModel> calendarNextPillSheetBandModels;
  final List<Diary> diaries;
  final List<Schedule> schedules;
  final PageController pageController;

  const MenstruationPageBody({
    Key? key,
    required this.store,
    required this.state,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: SizedBox(
          child: Text(
            state.displayMonth,
            style: const TextStyle(color: TextColor.black),
          ),
        ),
        backgroundColor: PilllColors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                MenstruationCalendarHeader(
                  pageController: pageController,
                  state: state,
                ),
                Expanded(
                  child: MenstruationCardList(store: store),
                ),
                const SizedBox(height: 40),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: MenstruationRecordButton(
                    state: state,
                    store: store,
                    onRecord: (menstruation) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Text("${DateTimeFormatter.monthAndDay(menstruation.beginDate)}から生理開始で記録しました"),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
