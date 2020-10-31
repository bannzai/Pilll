import 'package:Pilll/database/database.dart';
import 'package:Pilll/model/diary.dart';
import 'package:Pilll/provider/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/all.dart';

abstract class DiariesServiceInterface {
  Future<List<Diary>> fetchListForMonth(DateTime dateTimeOfMonth);
  Future<Diary> register(Diary diary);
  Future<Diary> update(Diary diary);
  Future<Diary> delete(Diary diary);
  Stream<List<Diary>> modifiedStream();
  Stream<List<Diary>> deletedStream();
}

final diaryServiceProvider = Provider<DiariesServiceInterface>(
    (ref) => DiaryService(ref.watch(databaseProvider)));

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

  List<DocumentChange> _filteredDeletedEventTypes(QuerySnapshot event) {
    return event.docChanges
        .where((element) => element.type == DocumentChangeType.removed);
  }

  @override
  Stream<List<Diary>> modifiedStream() {
    return _database
        .diariesReference()
        .snapshots()
        .where((element) => _filteredDeletedEventTypes(element).isEmpty)
        .map((event) =>
            event.docs.map((doc) => Diary.fromJson(doc.data())).toList());
  }

  @override
  Stream<List<Diary>> deletedStream() {
    return _database
        .diariesReference()
        .snapshots()
        .where((element) => _filteredDeletedEventTypes(element).isNotEmpty)
        .map((event) =>
            event.docs.map((doc) => Diary.fromJson(doc.data())).toList());
  }
}
