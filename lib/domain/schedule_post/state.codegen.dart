import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/database/schedule.dart';
import 'package:pilll/database/user.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';
import 'package:pilll/provider/shared_preference.dart';

part 'state.codegen.freezed.dart';

final schedulePostAsyncStateProvider = Provider.autoDispose.family<AsyncValue<SchedulePostState>, DateTime>((ref, date) {
  final user = ref.watch(userStreamProvider);
  final premiumAndTrial = ref.watch(premiumAndTrialProvider);
  final sharedPreferencesAsyncValue = ref.watch(sharedPreferenceProvider);
  final schedules = ref.watch(schedulesProvider(date));

  if (user is AsyncLoading || premiumAndTrial is AsyncLoading || sharedPreferencesAsyncValue is AsyncLoading || schedules is AsyncLoading) {
    return const AsyncValue.loading();
  }

  try {
    final sharedPreferences = sharedPreferencesAsyncValue.value!;

    return AsyncValue.data(
        SchedulePostState(date: date, user: user.value!, premiumAndTrial: premiumAndTrial.value!, schedules: schedules.value ?? []));
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace: stackTrace);
  }
});

@freezed
class SchedulePostState with _$SchedulePostState {
  factory SchedulePostState({
    required DateTime date,
    required User user,
    required PremiumAndTrial premiumAndTrial,
    required List<Schedule> schedules,
  }) = _SchedulePostState;
  SchedulePostState._();

  Schedule? schedule({required int index}) {
    if (schedules.length - 1 < index) {
      return null;
    }
    return schedules[index];
  }
}
