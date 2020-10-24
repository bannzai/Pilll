import 'package:Pilll/main/utility/utility.dart';
import 'package:Pilll/model/diary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary.freezed.dart';

@freezed
abstract class DiariesState implements _$DiariesState {
  DiariesState._();
  factory DiariesState({@Default([]) List<Diary> entities}) = _DiariesState;

  int _sort(Diary a, Diary b) => a.date.compareTo(b.date);

  List<Diary> diariesForMonth(DateTime dateTimeOfMonth) {
    entities
        .where((element) =>
            element.date.year == dateTimeOfMonth.year &&
            element.date.month == dateTimeOfMonth.month)
        .toList()
        .sort(_sort);
    return entities;
  }

  List<Diary> merged(List<Diary> diaries) {
    if (entities.isEmpty) {
      diaries.sort(_sort);
      return diaries;
    }
    final elementNotFound = -1;
    List<Diary> result = entities;
    result.sort(_sort);
    diaries.forEach((diary) {
      final indexForInsert = entities
          .lastIndexWhere((element) => diary.date.isBefore(element.date));
      if (indexForInsert != elementNotFound) {
        result.insert(indexForInsert, diary);
        return;
      }
      final indexForReplace =
          entities.indexWhere((element) => isSameDay(diary.date, element.date));
      if (indexForReplace != elementNotFound) {
        result[indexForReplace] = diary;
      }
      result.insert(0, diary);
    });
    return result;
  }
}
