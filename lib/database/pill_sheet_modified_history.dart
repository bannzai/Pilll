import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetModifiedHistoryDatabaseProvider =
    Provider<PillSheetModifiedHistoryDatabase>(
        (ref) => PillSheetModifiedHistoryDatabase(ref.watch(databaseProvider)));

class PillSheetModifiedHistoryDatabase {
  final DatabaseConnection _database;

  PillSheetModifiedHistoryDatabase(this._database);

  Future<List<PillSheetModifiedHistory>> fetchList(DateTime? after, int limit) {
    return _database
        .pillSheetModifiedHistoriesReference()
        .orderBy(
            PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate,
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
        .set(pillSheetModifiedHistory.toJson(), SetOptions(merge: true));
  }

  Stream<List<PillSheetModifiedHistory>> stream(int limit) {
    return _database
        .pillSheetModifiedHistoriesReference()
        .orderBy(
            PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate,
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
    on PillSheetModifiedHistoryDatabase {
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
      estimatedEventCausingDate: now(),
      createdAt: now(),
    );
  }

  static PillSheetModifiedHistory createTakenPillAction({
    required String? pillSheetGroupID,
    required PillSheet before,
    required PillSheet after,
    required bool isQuickRecord,
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
          isQuickRecord: isQuickRecord,
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
          pillSheetCreatedAt: now(),
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
          pillSheetDeletedAt: now(),
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

  static PillSheetModifiedHistory createBeganRestDurationAction({
    required String? pillSheetGroupID,
    required PillSheet before,
    required PillSheet after,
    required RestDuration restDuration,
  }) {
    assert(pillSheetGroupID != null);

    return _create(
      actionType: PillSheetModifiedActionType.beganRestDuration,
      value: PillSheetModifiedHistoryValue(
        beganRestDurationValue: BeganRestDurationValue(
          restDuration: restDuration,
        ),
      ),
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: before.id,
      afterPillSheetID: after.id,
      before: before,
      after: after,
    );
  }

  static PillSheetModifiedHistory createEndedRestDurationAction({
    required String? pillSheetGroupID,
    required PillSheet before,
    required PillSheet after,
    required RestDuration restDuration,
  }) {
    assert(pillSheetGroupID != null);

    return _create(
      actionType: PillSheetModifiedActionType.endedRestDuration,
      value: PillSheetModifiedHistoryValue(
        endedRestDurationValue: EndedRestDurationValue(
          restDuration: restDuration,
        ),
      ),
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: before.id,
      afterPillSheetID: after.id,
      before: before,
      after: after,
    );
  }

  static PillSheetModifiedHistory createChangedBeginDisplayNumberAction({
    required String? pillSheetGroupID,
    required DisplayNumberSetting? beforeDisplayNumberSetting,
    required DisplayNumberSetting afterDisplayNumberSetting,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.changedBeginDisplayNumber,
      value: PillSheetModifiedHistoryValue(
        changedBeginDisplayNumber: ChangedBeginDisplayNumberValue(
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
        ),
      ),
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: null,
      afterPillSheetID: null,
      before: null,
      after: null,
    );
  }

  static PillSheetModifiedHistory createChangedEndDisplayNumberAction({
    required String? pillSheetGroupID,
    required DisplayNumberSetting? beforeDisplayNumberSetting,
    required DisplayNumberSetting afterDisplayNumberSetting,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.changedEndDisplayNumber,
      value: PillSheetModifiedHistoryValue(
        changedEndDisplayNumber: ChangedEndDisplayNumberValue(
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
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

Future<void> updateForEditTakenValue({
  required PillSheetModifiedHistoryDatabase service,
  required DateTime actualTakenDate,
  required PillSheetModifiedHistory history,
  required PillSheetModifiedHistoryValue value,
  required TakenPillValue takenPillValue,
}) {
  final editedTakenPillValue = takenPillValue.copyWith(
    edited: TakenPillEditedValue(
      createdDate: DateTime.now(),
      actualTakenDate: actualTakenDate,
      historyRecordedDate: history.estimatedEventCausingDate,
    ),
  );
  final editedHistory = history.copyWith(
    estimatedEventCausingDate: actualTakenDate,
    value: value.copyWith(
      takenPill: editedTakenPillValue,
    ),
  );

  return service.update(editedHistory);
}
