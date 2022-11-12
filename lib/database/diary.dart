import 'package:pilll/database/database.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:pilll/util/datetime/day.dart';

final diaryDatastoreProvider = Provider<DiaryDatastore>((ref) => DiaryDatastore(ref.watch(databaseProvider)));

final diariesStreamForMonthProvider = StreamProvider.family((ref, DateTime dateForMonth) {
  final range = MonthDateTimeRange.monthRange(dateForMonth: dateForMonth);
  return ref
      .watch(databaseProvider)
      .diariesReference()
      .where(
        DiaryFirestoreKey.date,
        isGreaterThanOrEqualTo: range.start,
        isLessThanOrEqualTo: range.end,
      )
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList())
      .map((diaries) => sortedDiaries(diaries));
});

final diariesStream90Days = StreamProvider.family((ref, DateTime base) {
  return ref
      .watch(databaseProvider)
      .diariesReference()
      .where(DiaryFirestoreKey.date,
          isLessThanOrEqualTo: DateTime(base.year, base.month, 90), isGreaterThanOrEqualTo: DateTime(base.year, base.month, -90))
      .orderBy(DiaryFirestoreKey.date)
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList())
      .map((diaries) => sortedDiaries(diaries));
});

int sortDiary(Diary a, Diary b) => a.date.compareTo(b.date);
List<Diary> sortedDiaries(List<Diary> diaries) {
  diaries.sort(sortDiary);
  return diaries;
}

class DiaryDatastore {
  final DatabaseConnection _database;

  DiaryDatastore(this._database);

  // TODO: Remove
  Future<Diary> register(Diary diary) {
    return _database.diaryReference(diary).set(diary, SetOptions(merge: true)).then((_) => diary);
  }

  // TODO: Remove
  Future<Diary> update(Diary diary) {
    return _database.diaryReference(diary).set(diary, SetOptions(merge: true)).then((_) => diary);
  }

  // TODO: Remove
  Future<Diary> delete(Diary diary) {
    return _database.diaryReference(diary).delete().then((_) => diary);
  }

  Stream<List<Diary>> stream() =>
      _database.diariesReference().snapshots().map((event) => event.docs.map((e) => e.data()).toList()).map((diaries) => sortedDiaries(diaries));
}
