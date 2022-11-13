import 'package:pilll/database/database.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:pilll/util/datetime/day.dart';

final diaryDatastoreProvider = Provider<DiaryDatastore>((ref) => DiaryDatastore(ref.watch(databaseProvider)));

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
