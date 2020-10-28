import 'package:Pilll/model/diary.dart';
import 'package:Pilll/state/diary.dart';
import 'package:hooks_riverpod/all.dart';

class PostDiaryStore extends StateNotifier<DiaryState> {
  PostDiaryStore(DiaryState state) : super(state);

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
}
