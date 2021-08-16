import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_modified_history.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';
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
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.createdAt,
            descending: true)
        .startAfter([after])
        .limit(limit)
        .get()
        .then((reference) => reference.docs)
        .then((docs) => docs
            .map((doc) => PillSheetModifiedHistory.fromJson(
                (doc.data() as Map<String, dynamic>)
                  ..putIfAbsent("id", () => doc.id)))
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

  Future<PillSheetModifiedHistory> update(
      PillSheetModifiedHistory pillSheetModifiedHistory) async {
    await _database
        .pillSheetModifiedHistoriesReference()
        .doc(pillSheetModifiedHistory.id)
        .set(pillSheetModifiedHistory, SetOptions(merge: true));
    return pillSheetModifiedHistory;
  }

  Stream<List<PillSheetModifiedHistory>> subscribe(int limit) {
    return _database
        .pillSheetModifiedHistoriesReference()
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.createdAt,
            descending: true)
        .limit(limit)
        .snapshots()
        .map((reference) => reference.docs)
        .map((docs) => docs
            .map((doc) => PillSheetModifiedHistory.fromJson(
                (doc.data() as Map<String, dynamic>)
                  ..putIfAbsent("id", () => doc.id)))
            .toList());
  }

  add(WriteBatch batch, PillSheetModifiedHistory history) {
    batch.set(_database.pillSheetModifiedHistoriesReference().doc(),
        history.toJson(), SetOptions(merge: true));
  }
}

// Factories
extension PillSheetModifiedHistoryServiceActionFactory
    on PillSheetModifiedHistoryService {
  static PillSheetModifiedHistory _create({
    required PillSheet? before,
    required PillSheet after,
    required String afterID,
    required PillSheetModifiedActionType actionType,
    required PillSheetModifiedHistoryValue value,
  }) {
    return PillSheetModifiedHistory(
      id: null,
      actionType: actionType.name,
      value: value,
      beforeID: before?.id,
      before: before,
      afterID: afterID,
      after: after,
      estimatedEventCausingDate: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  static PillSheetModifiedHistory createTakenPillAction({
    required PillSheet? before,
    required PillSheet after,
  }) {
    final afterID = after.id;
    final afterLastTakenDate = after.lastTakenDate;
    if (afterID == null || afterLastTakenDate == null) {
      throw FormatException(
          "unexpected after pill sheet id or lastTakenDate is null id: ${after.id}, lastTakenDate: ${after.lastTakenDate} for takenPill action");
    }
    return _create(
      actionType: PillSheetModifiedActionType.takenPill,
      value: PillSheetModifiedHistoryValue(
        takenPill: TakenPillValue(
          afterLastTakenDate: afterLastTakenDate,
          afterLastTakenPillNumber: after.lastTakenPillNumber,
          beforeLastTakenDate: before?.lastTakenDate,
          beforeLastTakenPillNumber: before?.lastTakenPillNumber,
        ),
      ),
      after: after,
      afterID: afterID,
      before: before,
    );
  }

  static PillSheetModifiedHistory createCreatedPillSheetAction({
    required PillSheet? before,
    required PillSheet after,
  }) {
    final afterID = after.id;
    final afterLastTakenDate = after.lastTakenDate;
    if (afterID == null || afterLastTakenDate == null) {
      throw FormatException(
          "unexpected after pill sheet id or lastTakenDate is null id: ${after.id}, lastTakenDate: ${after.lastTakenDate} for takenPill action");
    }
    return _create(
      actionType: PillSheetModifiedActionType.createdPillSheet,
      value: PillSheetModifiedHistoryValue(
        createdPillSheet:
            CreatedPillSheetValue(pillSheetCreatedAt: DateTime.now()),
      ),
      after: after,
      afterID: afterID,
      before: before,
    );
  }
}
