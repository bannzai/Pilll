import 'package:pilll/database/database.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

final diaryDatastoreProvider = Provider<DiaryDatastore>(
    (ref) => DiaryDatastore(ref.watch(databaseProvider)));

final diariesStreamProvider =
    StreamProvider((ref) => ref.watch(diaryDatastoreProvider).stream());

final diariesStreamForMonthProvider = StreamProvider.family(
    (ref, DateTime dateForMonth) => ref
        .watch(diaryDatastoreProvider)
        .streamForMonth(dateForMonth: dateForMonth));

final diariesStreamAround90Days = StreamProvider.family((ref, DateTime base) =>
    ref.watch(diaryDatastoreProvider).streamForAround90Days(base: base));

int sortDiary(Diary a, Diary b) => a.date.compareTo(b.date);
List<Diary> sortedDiaries(List<Diary> diaries) {
  diaries.sort(sortDiary);
  return diaries;
}

class DiaryDatastore {
  final DatabaseConnection _database;

  DiaryDatastore(this._database);

  Future<List<Diary>> fetchListAround90Days(DateTime base) {
    return _database
        .diariesReference()
        .where(DiaryFirestoreKey.date,
            isLessThanOrEqualTo: DateTime(base.year, base.month, 90),
            isGreaterThanOrEqualTo: DateTime(base.year, base.month, -90))
        .orderBy(DiaryFirestoreKey.date)
        .get()
        .then((event) => event.docs.map((e) => e.data()).toList());
  }

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
        .then((event) => event.docs.map((e) => e.data()).toList());
  }

  Future<Diary> register(Diary diary) {
    return _database
        .diaryReference(diary)
        .set(diary, SetOptions(merge: true))
        .then((_) => diary);
  }

  Future<Diary> update(Diary diary) {
    return _database
        .diaryReference(diary)
        .set(diary, SetOptions(merge: true))
        .then((_) => diary);
  }

  Future<Diary> delete(Diary diary) {
    return _database.diaryReference(diary).delete().then((_) => diary);
  }

  late final Stream<List<Diary>> _stream = _database
      .diariesReference()
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList())
      .map((diaries) => sortedDiaries(diaries));
  Stream<List<Diary>> stream() => _stream;

  Stream<List<Diary>> streamForMonth({required DateTime dateForMonth}) {
    final firstDate = DateTime(dateForMonth.year, dateForMonth.month, 1);
    final lastDate = DateTime(dateForMonth.year, dateForMonth.month + 1, 0);
    return _database
        .diariesReference()
        .where(
          DiaryFirestoreKey.date,
          isGreaterThanOrEqualTo: firstDate,
          isLessThanOrEqualTo: lastDate,
        )
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList())
        .map((diaries) => sortedDiaries(diaries));
  }

  Stream<List<Diary>> streamForAround90Days({required DateTime base}) {
    return _database
        .diariesReference()
        .where(DiaryFirestoreKey.date,
            isLessThanOrEqualTo: DateTime(base.year, base.month, 90),
            isGreaterThanOrEqualTo: DateTime(base.year, base.month, -90))
        .orderBy(DiaryFirestoreKey.date)
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList())
        .map((diaries) => sortedDiaries(diaries));
  }
}
