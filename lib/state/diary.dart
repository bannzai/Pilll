import 'package:Pilll/model/diary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary.freezed.dart';

@freezed
abstract class DiariesState implements _$DiariesState {
  DiariesState._();
  factory DiariesState({@Default([]) List<Diary> entities}) = _DiariesState;
}
