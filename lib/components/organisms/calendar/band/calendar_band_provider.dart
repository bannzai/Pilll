import 'package:pilll/components/organisms/calendar/band/calendar_band_function.dart';
import 'package:pilll/components/organisms/calendar/band/calendar_band_model.dart';
import 'package:pilll/database/menstruation.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/setting.dart';
import 'package:riverpod/riverpod.dart';

final calendarMenstruationBandListProvider =
    Provider<AsyncValue<List<CalendarMenstruationBandModel>>>((ref) {
  final allMenstruations = ref.watch(allMenstruationStreamProvider);

  if (allMenstruations is AsyncLoading) {
    return const AsyncValue.loading();
  }

  try {
    return AsyncValue.data(
      allMenstruations.value!
          .map((menstruation) => CalendarMenstruationBandModel(menstruation))
          .toList(),
    );
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace);
  }
});

final calendarScheduledMenstruationBandListProvider =
    Provider<AsyncValue<List<CalendarScheduledMenstruationBandModel>>>((ref) {
  final allMenstruations = ref.watch(allMenstruationStreamProvider);
  final pillSheetGroup = ref.watch(latestPillSheetGroupStreamProvider);
  final setting = ref.watch(settingStreamProvider);

  if (allMenstruations is AsyncLoading ||
      pillSheetGroup is AsyncLoading ||
      setting is AsyncLoading) {
    return const AsyncValue.loading();
  }

  final pillSheetGroupValue = pillSheetGroup.value;
  final settingValue = setting.value;
  final allMenstruationsValue = allMenstruations.value;
  if (pillSheetGroupValue == null ||
      settingValue == null ||
      allMenstruationsValue == null) {
    return const AsyncValue.data([]);
  }

  try {
    return AsyncValue.data(
      scheduledOrInTheMiddleMenstruationDateRanges(
        pillSheetGroupValue,
        settingValue,
        allMenstruationsValue,
        15,
      )
          .map((dateRange) => CalendarScheduledMenstruationBandModel(
              dateRange.begin, dateRange.end))
          .toList(),
    );
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace);
  }
});

final calendarNextPillSheetBandListProvider =
    Provider<AsyncValue<List<CalendarNextPillSheetBandModel>>>((ref) {
  final pillSheetGroup = ref.watch(latestPillSheetGroupStreamProvider);

  if (pillSheetGroup is AsyncLoading) {
    return const AsyncValue.loading();
  }

  final pillSheetGroupValue = pillSheetGroup.value;
  if (pillSheetGroupValue == null) {
    return const AsyncValue.data([]);
  }

  try {
    return AsyncValue.data(
      nextPillSheetDateRanges(pillSheetGroupValue, 15)
          .map((dateRange) =>
              CalendarNextPillSheetBandModel(dateRange.begin, dateRange.end))
          .toList(),
    );
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace);
  }
});
