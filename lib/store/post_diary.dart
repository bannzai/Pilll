import 'package:Pilll/model/diary.dart';
import 'package:hooks_riverpod/all.dart';

class PostDiaryStore extends StateNotifier<Diary> {
  PostDiaryStore(Diary state) : super(state);

  void removePhysicalCondition(String physicalCondition) {
    state = state.copyWith(
        physicalConditions: state.physicalConditions
          ..remove(physicalCondition));
  }

  void addPhysicalCondition(String physicalCondition) {
    state = state.copyWith(
        physicalConditions: state.physicalConditions..add(physicalCondition));
  }

  void switchingPhysicalCondition(PhysicalConditionStatus type) {
    if (type == state.physicalConditionStatus) {
      state = state.copyWith(physicalConditionStatus: null);
      return;
    }
    state = state.copyWith(physicalConditionStatus: type);
  }
}
