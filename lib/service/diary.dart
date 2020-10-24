import 'package:Pilll/database/database.dart';
import 'package:Pilll/model/diary.dart';

abstract class DiaryServiceInterface {
  Future<List<Diary>> fetchListForMonth(DateTime dateTimeOfMonth);
}

class DiaryService extends DiaryServiceInterface {
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
}
