import 'package:async_value_group/async_value_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_provider.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/domain/calendar/components/month_calendar/month_calendar.dart';
import 'package:pilll/domain/menstruation/components/calendar/menstruation_calendar_header.dart';
import 'package:pilll/domain/menstruation/components/menstruation_card_list.dart';
import 'package:pilll/domain/menstruation/components/menstruation_record_button.dart';
import 'package:pilll/domain/menstruation/data.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/provider/diary.dart';
import 'package:pilll/provider/menstruation.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/schedule.dart';
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
    useAutomaticKeepAlive(wantKeepAlive: true);

    return AsyncValueGroup.group10(
      ref.watch(latestPillSheetGroupStreamProvider),
      ref.watch(premiumAndTrialProvider),
      ref.watch(allMenstruationProvider),
      ref.watch(latestMenstruationProvider),
      ref.watch(settingProvider),
      ref.watch(diariesStream90Days(today())),
      ref.watch(schedules90Days(today())),
      ref.watch(calendarMenstruationBandListProvider),
      ref.watch(calendarScheduledMenstruationBandListProvider),
      ref.watch(calendarNextPillSheetBandListProvider),
    ).when(
      data: (data) {
        return MenstruationPageBody(
          latestPillSheetGroup: data.t1,
          premiumAndTrial: data.t2,
          allMenstruation: data.t3,
          latestMenstruation: data.t4,
          setting: data.t5,
          diaries: data.t6,
          schedules: data.t7,
          calendarMenstruationBandModels: data.t8,
          calendarScheduledMenstruationBandModels: data.t9,
          calendarNextPillSheetBandModels: data.t10,
        );
      },
      error: (error, _) => UniversalErrorPage(
        error: error,
        child: null,
        reload: () => ref.refresh(refreshAppProvider),
      ),
      loading: () => const ScaffoldIndicator(),
    );
  }
}

class MenstruationPageBody extends HookConsumerWidget {
  final PillSheetGroup? latestPillSheetGroup;
  final PremiumAndTrial premiumAndTrial;
  final List<Menstruation> allMenstruation;
  final Menstruation? latestMenstruation;
  final Setting setting;
  final List<Diary> diaries;
  final List<Schedule> schedules;
  final List<CalendarMenstruationBandModel> calendarMenstruationBandModels;
  final List<CalendarScheduledMenstruationBandModel> calendarScheduledMenstruationBandModels;
  final List<CalendarNextPillSheetBandModel> calendarNextPillSheetBandModels;

  const MenstruationPageBody({
    Key? key,
    required this.latestPillSheetGroup,
    required this.premiumAndTrial,
    required this.allMenstruation,
    required this.latestMenstruation,
    required this.setting,
    required this.diaries,
    required this.schedules,
    required this.calendarMenstruationBandModels,
    required this.calendarScheduledMenstruationBandModels,
    required this.calendarNextPillSheetBandModels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = useState(todayCalendarPageIndex);
    final pageController = usePageController(initialPage: page.value);
    pageController.addListener(() {
      final pageControllerPage = pageController.page;
      if (pageControllerPage != null) {
        page.value = pageControllerPage.toInt();
      }
    });

    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: SizedBox(
          child: Text(_displayMonth(page.value), style: const TextStyle(color: TextColor.black)),
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
                  calendarMenstruationBandModels: calendarMenstruationBandModels,
                  calendarNextPillSheetBandModels: calendarNextPillSheetBandModels,
                  calendarScheduledMenstruationBandModels: calendarScheduledMenstruationBandModels,
                  diaries: diaries,
                  schedules: schedules,
                ),
                MenstruationCardList(
                  calendarScheduledMenstruationBandModels: calendarScheduledMenstruationBandModels,
                  premiumAndTrial: premiumAndTrial,
                  setting: setting,
                  latestPillSheetGroup: latestPillSheetGroup,
                  latestMenstruation: latestMenstruation,
                  allMenstruation: allMenstruation,
                ),
                const SizedBox(height: 40),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: MenstruationRecordButton(
                    latestMenstruation: latestMenstruation,
                    setting: setting,
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

  String _displayMonth(int page) => DateTimeFormatter.jaMonth(_targetEndDayOfWeekday(page));
  DateTime _targetEndDayOfWeekday(int page) {
    final diff = page - todayCalendarPageIndex;
    final base = today().add(Duration(days: diff * Weekday.values.length));
    return endDayOfWeekday(base);
  }
}
