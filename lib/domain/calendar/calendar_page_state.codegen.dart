import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_provider.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/domain/calendar/calendar_page_index_state_notifier.dart';
import 'package:pilll/domain/calendar/components/month_calendar/month_calendar_state.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:riverpod/riverpod.dart';

part 'calendar_page_state.codegen.freezed.dart';

const calendarDataSourceLength = 24;
final calendarDataSource =
    List.generate(calendarDataSourceLength, (index) => (index + 1) - 12)
        .map((e) => DateTime(today().year, today().month + e, 1))
        .toList();
final todayCalendarPageIndex = calendarDataSource
    .lastIndexWhere((element) => isSameMonth(element, today()));

final calendarPageStateProvider =
    Provider<AsyncValue<CalendarPageState>>((ref) {
  final pillSheetModifiedHistories =
      ref.watch(pillSheetModifiedHistoryStreamForLatest7);
  final premiumAndTrial = ref.watch(premiumAndTrialProvider);

  final calendarMenstruationBandModels =
      ref.watch(calendarMenstruationBandListProvider);
  final calendarScheduledMenstruationBandModels =
      ref.watch(calendarScheduledMenstruationBandListProvider);
  final calendarNextPillSheetBandModels =
      ref.watch(calendarNextPillSheetBandListProvider);

  final currentCalendarPageIndex =
      ref.watch(calendarPageIndexStateNotifierProvider);
  final monthCalendar = ref.watch(
      monthCalendarStateProvider(calendarDataSource[currentCalendarPageIndex]));

  final todayMonthCalendar = ref.watch(
      monthCalendarStateProvider(calendarDataSource[todayCalendarPageIndex]));

  if (pillSheetModifiedHistories is AsyncLoading ||
      premiumAndTrial is AsyncLoading ||
      calendarMenstruationBandModels is AsyncLoading ||
      calendarScheduledMenstruationBandModels is AsyncLoading ||
      calendarNextPillSheetBandModels is AsyncLoading ||
      monthCalendar is AsyncLoading ||
      todayMonthCalendar is AsyncLoading) {
    return const AsyncValue.loading();
  }

  try {
    return AsyncValue.data(CalendarPageState(
      currentCalendarIndex: currentCalendarPageIndex,
      currentMonthCalendar: monthCalendar.value!,
      todayMonthCalendar: todayMonthCalendar.value!,
      pillSheetModifiedHistories: pillSheetModifiedHistories.value!,
      premiumAndTrial: premiumAndTrial.value!,
      calendarMenstruationBandModels: calendarMenstruationBandModels.value!,
      calendarScheduledMenstruationBandModels:
          calendarScheduledMenstruationBandModels.value!,
      calendarNextPillSheetBandModels: calendarNextPillSheetBandModels.value!,
    ));
  } catch (error, _) {
    return AsyncValue.error(error);
  }
});

@freezed
class CalendarPageState with _$CalendarPageState {
  CalendarPageState._();
  factory CalendarPageState({
    required int currentCalendarIndex,
    required MonthCalendarState currentMonthCalendar,
    required MonthCalendarState todayMonthCalendar,
    required List<CalendarMenstruationBandModel> calendarMenstruationBandModels,
    required List<CalendarScheduledMenstruationBandModel>
        calendarScheduledMenstruationBandModels,
    required List<CalendarNextPillSheetBandModel>
        calendarNextPillSheetBandModels,
    required List<PillSheetModifiedHistory> pillSheetModifiedHistories,
    required PremiumAndTrial premiumAndTrial,
  }) = _CalendarPageState;

  DateTime get displayMonth => currentMonthCalendar.dateForMonth;
  String get displayMonthString => DateTimeFormatter.yearAndMonth(displayMonth);
}
