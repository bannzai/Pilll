import 'dart:async';

import 'state.codegen.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'state.codegen.dart';

final schedulePostStateNotifierProvider = StateNotifierProvider.autoDispose<SchedulePostStateNotifier, AsyncValue<SchedulePostState>>(
  (ref) => SchedulePostStateNotifier(
    initialState: ref.watch(schedulePostAsyncStateProvider),
    ref: ref,
  ),
);

class SchedulePostStateNotifier extends StateNotifier<AsyncValue<SchedulePostState>> {
  final Ref ref;
  SchedulePostStateNotifier({
    required AsyncValue<SchedulePostState> initialState,
    required this.ref,
  }) : super(initialState);

  Future<void> post() async {}
}
