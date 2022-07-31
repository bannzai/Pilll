import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:pilll/entity/diary_setting.codegen.dart';

part 'state.codegen.freezed.dart';

@freezed
class DiaryPostState with _$DiaryPostState {
  factory DiaryPostState({
    required Diary diary,
    required DiarySetting? diarySetting,
  }) = _DiaryPostState;
  DiaryPostState._();
}
