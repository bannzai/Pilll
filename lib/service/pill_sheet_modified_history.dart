import 'package:pilll/database/database.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/entity/pill_sheet_modified_history.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetModifiedHistoryServiceProvider =
    Provider<PillSheetModifiedHistoryService>(
        (ref) => PillSheetModifiedHistoryService(ref.watch(databaseProvider)));

class PillSheetModifiedHistoryService {
  final DatabaseConnection _database;

  PillSheetModifiedHistoryService(this._database);

  Future<List<PillSheetModifiedHistory>> fetchListForMonth(
      DateTime dateTimeOfMonth) {
    return _database
        .pillSheetModifiedHistoriesReference()
        .where(PillSheetModifiedHistoryFirestoreKeys.createdAt,
            isLessThanOrEqualTo:
                DateTime(dateTimeOfMonth.year, dateTimeOfMonth.month + 1, 0),
            isGreaterThanOrEqualTo:
                DateTime(dateTimeOfMonth.year, dateTimeOfMonth.month, 1))
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.createdAt)
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
