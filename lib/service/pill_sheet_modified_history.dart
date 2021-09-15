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

  Future<void> update(PillSheetModifiedHistory pillSheetModifiedHistory) async {
    await _database
        .pillSheetModifiedHistoriesReference()
        .doc(pillSheetModifiedHistory.id)
        .set(pillSheetModifiedHistory, SetOptions(merge: true));
    return;
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
    required PillSheet? after,
    required String? pillSheetGroupID,
    required String? beforePillSheetID,
    required String? afterPillSheetID,
    required PillSheetModifiedActionType actionType,
    required PillSheetModifiedHistoryValue value,
  }) {
    return PillSheetModifiedHistory(
      id: null,
      actionType: actionType.name,
      value: value,
      pillSheetID: null,
      pillSheetGroupID: pillSheetGroupID,
      afterPillSheetID: afterPillSheetID,
      beforePillSheetID: beforePillSheetID,
      before: before,
      after: after,
      estimatedEventCausingDate: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  static PillSheetModifiedHistory createTakenPillAction({
    required String? pillSheetGroupID,
    required PillSheet before,
    required PillSheet after,
  }) {
    assert(pillSheetGroupID != null);

    final afterID = after.id;
    final afterLastTakenDate = after.lastTakenDate;
    if (afterID == null || afterLastTakenDate == null) {
      throw FormatException(
          "unexpected afterPillSheetID: $afterID or lastTakenDate:${after.lastTakenDate} is null for takenPill action");
    }
    return _create(
      actionType: PillSheetModifiedActionType.takenPill,
      value: PillSheetModifiedHistoryValue(
        takenPill: TakenPillValue(
          afterLastTakenDate: afterLastTakenDate,
          afterLastTakenPillNumber: after.lastTakenPillNumber,
          beforeLastTakenDate: before.lastTakenDate,
          beforeLastTakenPillNumber: before.lastTakenPillNumber,
        ),
      ),
      after: after,
      beforePillSheetID: before.id,
      afterPillSheetID: afterID,
      pillSheetGroupID: pillSheetGroupID,
      before: before,
    );
  }

  static PillSheetModifiedHistory createRevertTakenPillAction({
    required String? pillSheetGroupID,
    required PillSheet before,
    required PillSheet after,
  }) {
    assert(pillSheetGroupID != null);

    final afterID = after.id;
    final afterLastTakenDate = after.lastTakenDate;
    if (afterID == null || afterLastTakenDate == null) {
      throw FormatException(
          "unexpected afterPillSheetID: $afterID or lastTakenDate:${after.lastTakenDate} is null for revertTakenPill action");
    }
    final beforeID = before.id;
    final beforeLastTakenDate = before.lastTakenDate;
    if (beforeID == null || beforeLastTakenDate == null) {
      throw FormatException(
          "unexpected before pill sheet id or lastTakenDate is null id: ${before.id}, lastTakenDate: ${before.lastTakenDate} for revertTakenPill action");
    }
    return _create(
      actionType: PillSheetModifiedActionType.revertTakenPill,
      value: PillSheetModifiedHistoryValue(
        revertTakenPill: RevertTakenPillValue(
          afterLastTakenDate: afterLastTakenDate,
          afterLastTakenPillNumber: after.lastTakenPillNumber,
          beforeLastTakenDate: beforeLastTakenDate,
          beforeLastTakenPillNumber: before.lastTakenPillNumber,
        ),
      ),
      after: after,
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: beforeID,
      afterPillSheetID: afterID,
      before: before,
    );
  }

  static PillSheetModifiedHistory createCreatedPillSheetAction({
    required String? pillSheetGroupID,
    required List<String> pillSheetIDs,
  }) {
    assert(pillSheetGroupID != null);

    return _create(
      actionType: PillSheetModifiedActionType.createdPillSheet,
      value: PillSheetModifiedHistoryValue(
        createdPillSheet: CreatedPillSheetValue(
          pillSheetCreatedAt: DateTime.now(),
          pillSheetIDs: pillSheetIDs,
        ),
      ),
      pillSheetGroupID: pillSheetGroupID,
      before: null,
      beforePillSheetID: null,
      after: null,
      afterPillSheetID: null,
    );
  }

  static PillSheetModifiedHistory createChangedPillNumberAction({
    required String? pillSheetGroupID,
    required PillSheet before,
    required PillSheet after,
  }) {
    assert(pillSheetGroupID != null);

    final afterID = after.id;
    if (afterID == null || pillSheetGroupID == null) {
      throw FormatException(
          "unexpected pillSheetGroupID: $pillSheetGroupID, or afterPillSheetID: $afterID  is null for changePillNumber action");
    }

    return _create(
      actionType: PillSheetModifiedActionType.changedPillNumber,
      value: PillSheetModifiedHistoryValue(
        changedPillNumber: ChangedPillNumberValue(
          afterBeginingDate: after.beginingDate,
          beforeBeginingDate: before.beginingDate,
          afterTodayPillNumber: after.todayPillNumber,
          beforeTodayPillNumber: before.todayPillNumber,
          beforeGroupIndex: before.groupIndex,
          afterGroupIndex: after.groupIndex,
        ),
      ),
      after: after,
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: before.id,
      afterPillSheetID: afterID,
      before: before,
    );
  }

  static PillSheetModifiedHistory createDeletedPillSheetAction({
    required String? pillSheetGroupID,
    required List<String> pillSheetIDs,
  }) {
    assert(pillSheetGroupID != null);

    return _create(
      actionType: PillSheetModifiedActionType.deletedPillSheet,
      value: PillSheetModifiedHistoryValue(
        deletedPillSheet: DeletedPillSheetValue(
          pillSheetDeletedAt: DateTime.now(),
          pillSheetIDs: pillSheetIDs,
        ),
      ),
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: null,
      afterPillSheetID: null,
      before: null,
      after: null,
    );
  }
}
