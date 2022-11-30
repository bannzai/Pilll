import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/diary.codegen.dart';
import 'package:riverpod/riverpod.dart';
import 'package:pilll/utils/datetime/day.dart';

final diaryForTodayProvider = StreamProvider((ref) {
  return ref
      .watch(databaseProvider)
      .diariesReference()
      .where(
        DiaryFirestoreKey.date,
        isGreaterThanOrEqualTo: today(),
        isLessThanOrEqualTo: today()..add(const Duration(days: 1)),
      )
      .limitToLast(1)
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList().lastOrNull);
});
final diariesForMonthProvider = StreamProvider.family((ref, DateTime dateForMonth) {
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
      .map((diaries) => _sortedDiaries(diaries));
});

final diariesFor90Days = StreamProvider.family((ref, DateTime base) {
  return ref
      .watch(databaseProvider)
      .diariesReference()
      .where(DiaryFirestoreKey.date,
          isLessThanOrEqualTo: DateTime(base.year, base.month, 90), isGreaterThanOrEqualTo: DateTime(base.year, base.month, -90))
      .orderBy(DiaryFirestoreKey.date)
      .snapshots()
      .map((event) => event.docs.map((e) => e.data()).toList())
      .map((diaries) => _sortedDiaries(diaries));
});

int _sortDiary(Diary a, Diary b) => a.date.compareTo(b.date);
List<Diary> _sortedDiaries(List<Diary> diaries) {
  diaries.sort(_sortDiary);
  return diaries;
}

final setDiaryProvider = Provider((ref) => SetDiary(ref.watch(databaseProvider)));

class SetDiary {
  final DatabaseConnection databaseConnection;
  SetDiary(this.databaseConnection);

  Future<void> call(Diary diary) async {
    await databaseConnection.diaryReference(diary).set(diary, SetOptions(merge: true));
  }
}

final deleteDiaryProvider = Provider((ref) => DeleteDiary(ref.watch(databaseProvider)));

class DeleteDiary {
  final DatabaseConnection databaseConnection;
  DeleteDiary(this.databaseConnection);

  Future<void> call(Diary diary) async {
    await databaseConnection.diaryReference(diary).delete();
  }
}
