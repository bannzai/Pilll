import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/diary_setting_physical_condtion_detail/state.codegen.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';
import 'package:pilll/util/datetime/day.dart';

import 'package:riverpod/riverpod.dart';

final diarySettingPhysicalConditionDetailStateNotifierProvider =
    StateNotifierProvider.autoDispose<DiarySettingPhysicalConditionDetailStateNotifier, AsyncValue<DiarySettingPhysicalConditionDetailState>>(
  (ref) => DiarySettingPhysicalConditionDetailStateNotifier(
    initialState: ref.watch(diarySettingPhysicalConditionDetailAsyncStateProvider),
  ),
);

class DiarySettingPhysicalConditionDetailStateNotifier extends StateNotifier<AsyncValue<DiarySettingPhysicalConditionDetailState>> {
  DiarySettingPhysicalConditionDetailStateNotifier({
    required AsyncValue<DiarySettingPhysicalConditionDetailState> initialState,
  }) : super(initialState);

  DiarySettingPhysicalConditionDetailState? get value => state.value;

  void select({required String physicalConditionDetail}) {
    state = AsyncValue.data(value!.copyWith(selected: value!.selected..add(physicalConditionDetail)));
  }

  void deleted() {
    state = AsyncValue.data(value!.copyWith(selected: []));
  }
}
