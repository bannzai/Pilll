import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_provider.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/domain/calendar/components/month/month_calendar.dart';
import 'package:pilll/domain/calendar/components/month/month_calendar_state.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:riverpod/riverpod.dart';

part 'calendar_page_state.codegen.freezed.dart';

final calendarDataSourceProvider = Provider((_) =>
    List.generate(24, (index) => (index + 1) - 12)
        .map((e) => DateTime(today().year, today().month + e, 1))
        .toList());
final todayCalendarIndexProvider = Provider((ref) => ref
    .watch(calendarDataSourceProvider)
    .lastIndexWhere((element) => isSameMonth(element, today())));
final currentCalendarPageIndexProvider =
    StateProvider((ref) => ref.watch(todayCalendarIndexProvider));

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
      ref.watch(currentCalendarPageIndexProvider.notifier).state;
  final calendarDataSource = ref.watch(calendarDataSourceProvider);
  final monthCalendar = ref.watch(
      monthCalendarStateProvider(calendarDataSource[currentCalendarPageIndex]));

  if (pillSheetModifiedHistories is AsyncLoading ||
      premiumAndTrial is AsyncLoading ||
      calendarMenstruationBandModels is AsyncLoading ||
      calendarScheduledMenstruationBandModels is AsyncLoading ||
      calendarNextPillSheetBandModels is AsyncLoading ||
      monthCalendar is AsyncLoading) {
    return const AsyncValue.loading();
  }

  try {
    return AsyncValue.data(CalendarPageState(
        currentCalendarIndex: currentCalendarPageIndex,
        pillSheetModifiedHistories: pillSheetModifiedHistories.value!,
        premiumAndTrial: premiumAndTrial.value!,
        calendarMenstruationBandModels: calendarMenstruationBandModels.value!,
        calendarScheduledMenstruationBandModels:
            calendarScheduledMenstruationBandModels.value!,
        calendarNextPillSheetBandModels:
            calendarNextPillSheetBandModels.value!));
  } catch (error, _) {
    return AsyncValue.error(error);
  }
});

@freezed
class CalendarPageState with _$CalendarPageState {
  CalendarPageState._();
  factory CalendarPageState({
    required int currentCalendarIndex,
    required MonthCalendar currentMonthCalendar,
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
