import 'package:pilll/database/diary_setting.dart';
import 'package:pilll/domain/diary/diary_state.codegen.dart';
import 'package:pilll/domain/diary_post/diary_post_state_provider_family.dart';
import 'package:pilll/domain/diary_post/state.codegen.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/database/diary.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final diaryPostStateNotifierProvider =
    StateNotifierProvider.autoDispose.family<DiaryPostStateNotifier, DiaryState, DiaryPostStateProviderFamily>((ref, family) {
  final diarySetting = ref.watch(diarySettingStreamProvider).asData?.value;
  final service = ref.watch(diaryDatastoreProvider);
  final diary = family.diary;
  if (diary == null) {
    return DiaryPostStateNotifier(service, DiaryPostState(diary: Diary.fromDate(family.date), diarySetting: diarySetting));
  }
  return DiaryPostStateNotifier(service, DiaryPostState(diary: diary.copyWith(), diarySetting: diarySetting));
});

class DiaryPostStateNotifier extends StateNotifier<DiaryPostState> {
  final DiaryDatastore _diaryDatastore;
  DiaryPostStateNotifier(this._diaryDatastore, DiaryPostState state) : super(state);

  void removePhysicalCondition(String physicalCondition) {
    state = state.copyWith(diary: state.diary.copyWith(physicalConditions: state.diary.physicalConditions..remove(physicalCondition)));
  }

  void addPhysicalCondition(String physicalCondition) {
    state = state.copyWith(diary: state.diary.copyWith(physicalConditions: state.diary.physicalConditions..add(physicalCondition)));
  }

  void switchingPhysicalCondition(PhysicalConditionStatus status) {
    if (state.diary.hasPhysicalConditionStatusFor(status)) {
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
