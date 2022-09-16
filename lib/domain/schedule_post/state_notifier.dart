import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/schedule.codegen.dart';

import 'state.codegen.dart';
import 'package:riverpod/riverpod.dart';

final schedulePostStateNotifierProvider =
    StateNotifierProvider.autoDispose.family<SchedulePostStateNotifier, AsyncValue<SchedulePostState>, DateTime>(
  (ref, DateTime date) => SchedulePostStateNotifier(
    initialState: ref.watch(schedulePostAsyncStateProvider(date)),
    ref: ref,
  ),
);

class SchedulePostStateNotifier extends StateNotifier<AsyncValue<SchedulePostState>> {
  final Ref ref;
  SchedulePostStateNotifier({
    required AsyncValue<SchedulePostState> initialState,
    required this.ref,
  }) : super(initialState);

  Future<void> post({required Schedule schedule}) async {
    await ref.read(databaseProvider).schedulesReference().doc().set(schedule, SetOptions(merge: true));
  }
}
