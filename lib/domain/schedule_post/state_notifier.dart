import 'dart:async';

import 'state.codegen.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'state.codegen.dart';

final schedulePostStateNotifierProvider = StateNotifierProvider.autoDispose<SchedulePostStateNotifier, AsyncValue<SchedulePostState>>(
  (ref) => SchedulePostStateNotifier(
    initialState: ref.watch(schedulePostAsyncStateProvider),
  ),
);

class SchedulePostStateNotifier extends StateNotifier<AsyncValue<SchedulePostState>> {
  SchedulePostStateNotifier({
    required AsyncValue<SchedulePostState> initialState,
  }) : super(initialState);
}
