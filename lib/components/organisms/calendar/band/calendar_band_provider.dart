import 'package:async_value_group/async_value_group.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_function.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/provider/menstruation.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/setting.dart';
import 'package:riverpod/riverpod.dart';

final calendarMenstruationBandListProvider = Provider<AsyncValue<List<CalendarMenstruationBandModel>>>((ref) {
  final allMenstruations = ref.watch(allMenstruationProvider);

  if (allMenstruations is AsyncLoading) {
    return const AsyncValue.loading();
  }

  try {
    return AsyncValue.data(
      allMenstruations.value!.map((menstruation) => CalendarMenstruationBandModel(menstruation)).toList(),
    );
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace);
  }
});

final calendarScheduledMenstruationBandListProvider = Provider<AsyncValue<List<CalendarScheduledMenstruationBandModel>>>((ref) {
  return AsyncValueGroup.group3(
    ref.watch(latestPillSheetGroupProvider),
    ref.watch(settingProvider),
    ref.watch(allMenstruationProvider),
  ).whenData(
    (t) => scheduledMenstruationDateRanges(
      t.t1,
      t.t2,
      t.t3,
    ).map((dateRange) => CalendarScheduledMenstruationBandModel(dateRange.begin, dateRange.end)).toList(),
  );
});

final calendarNextPillSheetBandListProvider = Provider<AsyncValue<List<CalendarNextPillSheetBandModel>>>((ref) {
  final pillSheetGroup = ref.watch(latestPillSheetGroupProvider);

  if (pillSheetGroup is AsyncLoading) {
    return const AsyncValue.loading();
  }

  final pillSheetGroupValue = pillSheetGroup.value;
  if (pillSheetGroupValue == null) {
    return const AsyncValue.data([]);
  }

  try {
    return AsyncValue.data(
      nextPillSheetDateRanges(pillSheetGroupValue, 15).map((dateRange) => CalendarNextPillSheetBandModel(dateRange.begin, dateRange.end)).toList(),
    );
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace);
  }
});
