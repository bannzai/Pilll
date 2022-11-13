import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/database/user.dart';
import 'package:pilll/entity/schedule.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/provider/premium_and_trial.codegen.dart';

part 'state.codegen.freezed.dart';

final schedulePostAsyncStateProvider = Provider.autoDispose.family<AsyncValue<SchedulePostState>, DateTime>((ref, date) {
  final user = ref.watch(userStreamProvider);
  final premiumAndTrial = ref.watch(premiumAndTrialProvider);
  final schedules = ref.watch(schedulesForDateProvider(date));

  if (user is AsyncLoading || premiumAndTrial is AsyncLoading || schedules is AsyncLoading) {
    return const AsyncValue.loading();
  }

  try {
    return AsyncValue.data(
        SchedulePostState(date: date, user: user.value!, premiumAndTrial: premiumAndTrial.value!, schedules: schedules.value ?? []));
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace);
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

  Schedule? scheduleOrNull({required int index}) {
    if (schedules.length - 1 < index) {
      return null;
    }
    return schedules[index];
  }
}
