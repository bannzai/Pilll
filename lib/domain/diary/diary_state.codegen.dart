import 'package:pilll/entity/diary.codegen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_state.codegen.freezed.dart';

@freezed
class DiaryState with _$DiaryState {
  const DiaryState._();
  const factory DiaryState({
    required Diary diary,
  }) = _DiaryState;
}
