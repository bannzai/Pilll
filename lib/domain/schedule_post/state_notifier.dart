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
    read: ref.read,
  ),
);

class SchedulePostStateNotifier extends StateNotifier<AsyncValue<SchedulePostState>> {
  final Reader read;
  SchedulePostStateNotifier({
    required AsyncValue<SchedulePostState> initialState,
    required this.read,
  }) : super(initialState);

  Future<void> post({required Schedule schedule}) async {
    await read(databaseProvider).schedulesReference().doc().set(schedule, SetOptions(merge: true));
  }
}
