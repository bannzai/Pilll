import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet_modified_history.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetModifiedHistoryServiceProvider =
    Provider<PillSheetModifiedHistoryService>(
        (ref) => PillSheetModifiedHistoryService(ref.watch(databaseProvider)));

class PillSheetModifiedHistoryService {
  final DatabaseConnection _database;

  PillSheetModifiedHistoryService(this._database);

  Future<List<PillSheetModifiedHistory>> fetchList(DateTime? after, int limit) {
    return _database
        .pillSheetModifiedHistoriesReference()
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.createdAt)
        .startAfter([after])
        .limit(limit)
        .get()
        .then((reference) => reference.docs)
        .then((docs) => docs
            .map((doc) => doc.data())
            .whereType<Map<String, dynamic>>()
            .map((data) => PillSheetModifiedHistory.fromJson(data))
            .toList());
  }

  Future<List<PillSheetModifiedHistory>> fetchAll() {
    return _database
        .pillSheetModifiedHistoriesReference()
        .get()
        .then((reference) => reference.docs)
        .then((docs) => docs
            .map((doc) => doc.data())
            .whereType<Map<String, dynamic>>()
            .map((data) => PillSheetModifiedHistory.fromJson(data))
            .toList());
  }

  Stream<List<PillSheetModifiedHistory>> subscribeForMonth(
      DateTime dateTimeOfMonth) {
    return _database
        .pillSheetModifiedHistoriesReference()
        .where(PillSheetModifiedHistoryFirestoreKeys.createdAt,
            isLessThanOrEqualTo:
                DateTime(dateTimeOfMonth.year, dateTimeOfMonth.month + 1, 0),
            isGreaterThanOrEqualTo:
                DateTime(dateTimeOfMonth.year, dateTimeOfMonth.month, 1))
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.createdAt)
        .snapshots()
        .map((reference) => reference.docs)
        .map((docs) => docs
            .map((doc) => doc.data())
            .whereType<Map<String, dynamic>>()
            .map((data) => PillSheetModifiedHistory.fromJson(data))
            .toList());
  }
}
