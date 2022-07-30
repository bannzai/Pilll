import 'package:pilll/domain/diary/diary_state.codegen.dart';
import 'package:pilll/domain/diary_post/diary_post_store_provider_family.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/database/diary.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final diaryPostStateNotifierProvider =
    StateNotifierProvider.autoDispose.family<DiaryPostStateNotifier, DiaryState, DiaryPostStoreProviderFamily>((ref, family) {
  final service = ref.watch(diaryDatastoreProvider);
  final diary = family.diary;
  if (diary == null) {
    return DiaryPostStateNotifier(service, DiaryState(diary: Diary.fromDate(family.date)));
  }
  return DiaryPostStateNotifier(service, DiaryState(diary: diary.copyWith()));
});

class DiaryPostStateNotifier extends StateNotifier<DiaryState> {
  final DiaryDatastore _diaryDatastore;
  DiaryPostStateNotifier(this._diaryDatastore, DiaryState state) : super(state);

  void removePhysicalCondition(String physicalCondition) {
    state = state.copyWith(diary: state.diary.copyWith(physicalConditions: state.diary.physicalConditions..remove(physicalCondition)));
  }

  void addPhysicalCondition(String physicalCondition) {
    state = state.copyWith(diary: state.diary.copyWith(physicalConditions: state.diary.physicalConditions..add(physicalCondition)));
  }

  void switchingPhysicalCondition(PhysicalConditionStatus status) {
    if (state.hasPhysicalConditionStatusFor(status)) {
      state = state.copyWith(diary: state.diary.copyWith(physicalConditionStatus: null));
      return;
    }
    state = state.copyWith(diary: state.diary.copyWith(physicalConditionStatus: status));
  }

  void toggleHasSex() {
    state = state.copyWith(diary: state.diary.copyWith(hasSex: !state.diary.hasSex));
  }

  void editedMemo(String text) {
    state = state.copyWith(diary: state.diary.copyWith(memo: text));
  }

  Future<Diary> register() {
    return _diaryDatastore.register(state.diary);
  }

  Future<void> delete() {
    return _diaryDatastore.delete(state.diary);
  }
}
