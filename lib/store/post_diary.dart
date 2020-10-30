import 'package:Pilll/model/diary.dart';
import 'package:Pilll/service/diary.dart';
import 'package:Pilll/state/diary.dart';
import 'package:hooks_riverpod/all.dart';

class PostDiaryStore extends StateNotifier<DiaryState> {
  final DiaryService _service;
  PostDiaryStore(this._service, DiaryState state) : super(state);

  void removePhysicalCondition(String physicalCondition) {
    state = state.copyWith(
        entity: state.entity.copyWith(
            physicalConditions: state.entity.physicalConditions
              ..remove(physicalCondition)));
  }

  void addPhysicalCondition(String physicalCondition) {
    state = state.copyWith(
        entity: state.entity.copyWith(
            physicalConditions: state.entity.physicalConditions
              ..add(physicalCondition)));
  }

  void switchingPhysicalCondition(PhysicalConditionStatus status) {
    if (state.hasPhysicalConditionStatus(status)) {
      state = state.copyWith(
          entity: state.entity.copyWith(physicalConditionStatus: null));
      return;
    }
    state = state.copyWith(
        entity: state.entity.copyWith(physicalConditionStatus: status));
  }

  void toggleHasSex() {
    state = state.copyWith(
        entity: state.entity.copyWith(hasSex: !state.entity.hasSex));
  }

  void editedMemo(String text) {
    state = state.copyWith(entity: state.entity.copyWith(memo: text));
  }

  Future<Diary> register() {
    return _service.register(state.entity);
  }

  Future<void> delete() {
    return _service.delete(state.entity);
  }
}
