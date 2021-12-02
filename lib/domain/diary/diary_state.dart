import 'package:pilll/entity/diary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_state.freezed.dart';

@freezed
abstract class DiaryState implements _$DiaryState {
  DiaryState._();
  factory DiaryState({
    required Diary diary,
  }) = _DiaryState;

  bool hasPhysicalConditionStatusFor(PhysicalConditionStatus status) =>
      diary.physicalConditionStatus == status;

  bool hasPhysicalConditionStatus() => diary.hasPhysicalConditionStatus;
}
