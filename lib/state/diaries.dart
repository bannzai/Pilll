import 'package:Pilll/utility/utility.dart';
import 'package:Pilll/entity/diary.dart';
import 'package:Pilll/service/diary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diaries.freezed.dart';

@freezed
abstract class DiariesState implements _$DiariesState {
  DiariesState._();
  factory DiariesState({@Default([]) List<Diary> entities}) = _DiariesState;

  List<Diary> diariesForMonth(DateTime dateTimeOfMonth) {
    entities
        .where((element) =>
            element.date.year == dateTimeOfMonth.year &&
            element.date.month == dateTimeOfMonth.month)
        .toList()
        .sort(sortDiary);
    return entities;
  }

  Diary diaryForDatetimeOrNull(DateTime dateTime) {
    final filtered =
        entities.where((element) => isSameDay(element.date, dateTime));
    if (filtered.isEmpty) {
      return null;
    }
    return filtered.last;
  }

  Diary diaryForDateTime(DateTime dateTime) =>
      entities.lastWhere((element) => isSameDay(element.date, dateTime));
}
