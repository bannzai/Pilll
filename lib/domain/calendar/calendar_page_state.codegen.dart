import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_provider.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/util/datetime/date_compare.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:riverpod/riverpod.dart';

part 'calendar_page_state.codegen.freezed.dart';

final currentCalendarPageIndexProvider = StateProvider((ref) => 0);
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

  if (pillSheetModifiedHistories is AsyncLoading ||
      premiumAndTrial is AsyncLoading ||
      calendarMenstruationBandModels is AsyncLoading ||
      calendarScheduledMenstruationBandModels is AsyncLoading ||
      calendarNextPillSheetBandModels is AsyncLoading) {
    return const AsyncValue.loading();
  }

  try {
    return AsyncValue.data(CalendarPageState(
        currentCalendarIndex: ref.watch(currentCalendarPageIndexProvider),
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
    required List<CalendarMenstruationBandModel> calendarMenstruationBandModels,
    required List<CalendarScheduledMenstruationBandModel>
        calendarScheduledMenstruationBandModels,
    required List<CalendarNextPillSheetBandModel>
        calendarNextPillSheetBandModels,
    required List<PillSheetModifiedHistory> pillSheetModifiedHistories,
    required PremiumAndTrial premiumAndTrial,
  }) = _CalendarPageState;

  final List<DateTime> calendarDataSource = _calendarDataSource();
  int get todayCalendarIndex => calendarDataSource
      .lastIndexWhere((element) => isSameMonth(element, today()));
  DateTime get displayMonth => calendarDataSource[currentCalendarIndex];
  String get displayMonthString => DateTimeFormatter.yearAndMonth(displayMonth);
}

List<DateTime> _calendarDataSource() {
  final base = today();
  return List.generate(24, (index) => (index + 1) - 12)
      .map((e) => DateTime(base.year, base.month + e, 1))
      .toList();
}
