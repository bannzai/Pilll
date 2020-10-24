import 'package:Pilll/model/diary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary.freezed.dart';

@freezed
abstract class DiariesState implements _$DiariesState {
  DiariesState._();
  factory DiariesState({@Default([]) List<Diary> entities}) = _DiariesState;

  List<Diary> diariesForMonth(DateTime dateTimeOfMonth) {
    return entities.where((element) =>
        element.date.year == dateTimeOfMonth.year &&
        element.date.month == dateTimeOfMonth.month);
  }
}
