import 'package:Pilll/database/database.dart';
import 'package:Pilll/model/diary.dart';
import 'package:Pilll/provider/auth.dart';
import 'package:riverpod/all.dart';

abstract class DiariesServiceInterface {
  Future<List<Diary>> fetchListForMonth(DateTime dateTimeOfMonth);
  Future<Diary> register(Diary diary);
  Future<Diary> update(Diary diary);
  Stream<List<Diary>> subscribe();
}

final diariesServiceProvider = Provider<DiariesServiceInterface>(
    (ref) => DiariesService(ref.watch(databaseProvider)));

class DiariesService extends DiariesServiceInterface {
  final DatabaseConnection _database;

  DiariesService(this._database);

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
        .update(diary.toJson())
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
  Stream<List<Diary>> subscribe() {
    return _database
        .diariesReference()
        .snapshots()
        .map((event) => event.docs.map((doc) => Diary.fromJson(doc.data())));
  }
}
