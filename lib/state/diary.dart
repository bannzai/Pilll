import 'package:pilll/entity/diary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary.freezed.dart';

@freezed
abstract class DiaryState implements _$DiaryState {
  DiaryState._();
  factory DiaryState({required Diary entity}) = _DiaryState;

  bool hasPhysicalConditionStatusFor(PhysicalConditionStatus status) =>
      entity.physicalConditionStatus == status;

  bool hasPhysicalConditionStatus() => entity.physicalConditionStatus != null;
}
