import 'package:async_value_group/async_value_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_provider.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/calendar/components/const.dart';
import 'package:pilll/features/menstruation/components/calendar/menstruation_calendar_header.dart';
import 'package:pilll/features/menstruation/components/menstruation_card_list.dart';
import 'package:pilll/features/menstruation/components/menstruation_record_button.dart';
import 'package:pilll/features/menstruation/data.dart';
import 'package:pilll/features/record/weekday_badge.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/menstruation.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:pilll/features/error/universal_error_page.dart';
import 'package:pilll/provider/diary.dart';
import 'package:pilll/provider/menstruation.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/user.dart';
import 'package:pilll/provider/root.dart';
import 'package:pilll/provider/schedule.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:pilll/utils/formatter/date_time_formatter.dart';

abstract class MenstruationPageConst {
  static const double calendarHeaderDropShadowOffset = 2;
  static const double tileHeight = CalendarConstants.tileHeight + calendarHeaderDropShadowOffset;
  static const double calendarHeaderHeight = WeekdayBadgeConst.height + tileHeight;
}

class MenstruationPage extends HookConsumerWidget {
  const MenstruationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive(wantKeepAlive: true);

    return AsyncValueGroup.group10(
      ref.watch(latestPillSheetGroupProvider),
      ref.watch(userProvider),
      ref.watch(allMenstruationProvider),
      ref.watch(latestMenstruationProvider),
      ref.watch(settingProvider),
      ref.watch(diariesFor90Days(today())),
      ref.watch(schedules90Days(today())),
      ref.watch(calendarMenstruationBandListProvider),
      ref.watch(calendarScheduledMenstruationBandListProvider),
      ref.watch(calendarNextPillSheetBandListProvider),
    ).when(
      data: (data) {
        return MenstruationPageBody(
          latestPillSheetGroup: data.$1,
          user: data.$2,
          allMenstruation: data.$3,
          latestMenstruation: data.$4,
          setting: data.$5,
          diaries: data.$6,
          schedules: data.$7,
          calendarMenstruationBandModels: data.$8,
          calendarScheduledMenstruationBandModels: data.$9,
          calendarNextPillSheetBandModels: data.$10,
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
  final User user;
  final List<Menstruation> allMenstruation;
  final Menstruation? latestMenstruation;
  final Setting setting;
  final List<Diary> diaries;
  final List<Schedule> schedules;
  final List<CalendarMenstruationBandModel> calendarMenstruationBandModels;
  final List<CalendarScheduledMenstruationBandModel> calendarScheduledMenstruationBandModels;
  final List<CalendarNextPillSheetBandModel> calendarNextPillSheetBandModels;

  const MenstruationPageBody({
    super.key,
    required this.latestPillSheetGroup,
    required this.user,
    required this.allMenstruation,
    required this.latestMenstruation,
    required this.setting,
    required this.diaries,
    required this.schedules,
    required this.calendarMenstruationBandModels,
    required this.calendarScheduledMenstruationBandModels,
    required this.calendarNextPillSheetBandModels,
  });

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
                  user: user,
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
                ),
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
    final base = today().addDays(diff * Weekday.values.length);
    return endDayOfWeekday(base);
  }
}
