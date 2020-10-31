import 'package:Pilll/main/utility/utility.dart';
import 'package:Pilll/model/diary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diaries.freezed.dart';

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

  List<Diary> reduced(List<Diary> diaries) {
    if (entities.isEmpty) {
      assert(false, "unexpected source diaries is empty");
      diaries.sort(_sort);
      return diaries;
    }

    final elementNotFound = -1;
    List<Diary> result = [];
    result.sort(_sort);
    diaries.forEach((diary) {
      final indexForDelete = entities
          .lastIndexWhere((element) => isSameDay(diary.date, element.date));
      if (indexForDelete != elementNotFound) {
        return;
      }
      assert(false, "unexpected deleted index not found ${diary.date}");
      result.add(diary);
    });
    return result;
  }
}
