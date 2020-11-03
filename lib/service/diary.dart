import 'package:Pilll/database/database.dart';
import 'package:Pilll/entity/diary.dart';
import 'package:Pilll/auth/auth.dart/';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/all.dart';

abstract class DiariesServiceInterface {
  Future<List<Diary>> fetchListForMonth(DateTime dateTimeOfMonth);
  Future<Diary> register(Diary diary);
  Future<Diary> update(Diary diary);
  Future<Diary> delete(Diary diary);
  Stream<List<Diary>> subscribe();
}

final diaryServiceProvider = Provider<DiariesServiceInterface>(
    (ref) => DiaryService(ref.watch(databaseProvider)));

int sortDiary(Diary a, Diary b) => a.date.compareTo(b.date);
List<Diary> sortedDiaries(List<Diary> diaries) {
  diaries.sort(sortDiary);
  return diaries;
}

class DiaryService extends DiariesServiceInterface {
  final DatabaseConnection _database;

  DiaryService(this._database);

  @override
  Future<List<Diary>> fetchListForMonth(DateTime dateTimeOfMonth) {
    return _database
        .diariesReference()
        .where(DiaryFirestoreKey.date,
            isLessThanOrEqualTo:
                DateTime(dateTimeOfMonth.year, dateTimeOfMonth.month + 1, 0),
            isGreaterThanOrEqualTo:
                DateTime(dateTimeOfMonth.year, dateTimeOfMonth.month, 1))
        .orderBy(DiaryFirestoreKey.date)
        .get()
        .then((event) =>
            event.docs.map((doc) => Diary.fromJson(doc.data())).toList());
  }

  @override
  Future<Diary> register(Diary diary) {
    return _database
        .diaryReference(diary)
        .set(diary.toJson(), SetOptions(merge: true))
        .then((_) => diary);
  }

  @override
  Future<Diary> update(Diary diary) {
    return _database
        .diaryReference(diary)
        .update(diary.toJson())
        .then((_) => diary);
  }

  @override
  Future<Diary> delete(Diary diary) {
    return _database.diaryReference(diary).delete().then((_) => diary);
  }

  @override
  Stream<List<Diary>> subscribe() {
    return _database
        .diariesReference()
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => Diary.fromJson(doc.data())).toList())
        .map((diaries) => sortedDiaries(diaries));
  }
}
