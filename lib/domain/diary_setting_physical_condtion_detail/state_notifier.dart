import 'package:pilll/domain/diary_setting_physical_condtion_detail/state.codegen.dart';

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
}
