import 'package:Pilll/model/diary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary.freezed.dart';

@freezed
abstract class DiaryState implements _$DiaryState {
  DiaryState._();
  factory DiaryState({@Default([]) List<Diary> entities}) = _DiaryState;
}
