import 'package:pilll/database/diary_setting.dart';
import 'package:pilll/domain/diary/diary_state.codegen.dart';
import 'package:pilll/domain/diary_post/diary_post_state_provider_family.dart';
import 'package:pilll/domain/diary_post/state.codegen.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/database/diary.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final diaryPostStateNotifierProvider =
    StateNotifierProvider.autoDispose.family<DiaryPostStateNotifier, AsyncValue<DiaryPostState>, DiaryPostStateProviderFamily>((ref, family) {
  return DiaryPostStateNotifier(ref.watch(diaryDatastoreProvider), ref.watch(diaryPostAsyncStateProvider(family)));
});

class DiaryPostStateNotifier extends StateNotifier<AsyncValue<DiaryPostState>> {
  final DiaryDatastore _diaryDatastore;
  DiaryPostStateNotifier(this._diaryDatastore, AsyncValue<DiaryPostState> initialState) : super(initialState);

  DiaryPostState get value => state.value!;

  void removePhysicalCondition(String physicalCondition) {
    state =
        AsyncValue.data(value.copyWith(diary: value.diary.copyWith(physicalConditions: value.diary.physicalConditions..remove(physicalCondition))));
  }

  void addPhysicalCondition(String physicalCondition) {
    state = AsyncValue.data(value.copyWith(diary: value.diary.copyWith(physicalConditions: value.diary.physicalConditions..add(physicalCondition))));
  }

  void switchingPhysicalCondition(PhysicalConditionStatus status) {
    if (value.diary.hasPhysicalConditionStatusFor(status)) {
      state = AsyncValue.data(value.copyWith(diary: value.diary.copyWith(physicalConditionStatus: null)));
      return;
    }
    state = AsyncValue.data(value.copyWith(diary: value.diary.copyWith(physicalConditionStatus: status)));
  }

  void toggleHasSex() {
    state = AsyncValue.data(value.copyWith(diary: value.diary.copyWith(hasSex: !value.diary.hasSex)));
  }

  void editedMemo(String text) {
    state = AsyncValue.data(value.copyWith(diary: value.diary.copyWith(memo: text)));
  }

  Future<Diary> register() {
    return _diaryDatastore.register(value.diary);
  }

  Future<void> delete() {
    return _diaryDatastore.delete(value.diary);
  }
}
