import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pill_sheet_modified_history.g.dart';

@Riverpod(dependencies: [database])
Stream<List<PillSheetModifiedHistory>> pillSheetModifiedHistories(PillSheetModifiedHistoriesRef ref, {String? afterCursor}) {
  if (afterCursor != null) {
    return ref
        .watch(databaseProvider)
        .pillSheetModifiedHistoriesReference()
        .where(
          PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate,
          isLessThanOrEqualTo: today().add(const Duration(days: 1)),
          isGreaterThanOrEqualTo: today().subtract(const Duration(days: PillSheetModifiedHistoryServiceActionFactory.limitDays)),
        )
        .where(PillSheetModifiedHistoryFirestoreKeys.archivedDateTime, isNull: true)
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
        .startAfter([afterCursor])
        .limit(20)
        .snapshots()
        .map((reference) => reference.docs)
        .map((docs) => docs.map((doc) => doc.data()).toList());
  } else {
    return ref
        .watch(databaseProvider)
        .pillSheetModifiedHistoriesReference()
        .where(
          PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate,
          isLessThanOrEqualTo: today().add(const Duration(days: 1)),
          isGreaterThanOrEqualTo: today().subtract(const Duration(days: PillSheetModifiedHistoryServiceActionFactory.limitDays)),
        )
        .where(PillSheetModifiedHistoryFirestoreKeys.archivedDateTime, isNull: true)
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
        .limit(20)
        .snapshots()
        .map((reference) => reference.docs)
        .map((docs) => docs.map((doc) => doc.data()).toList());
  }
}

@Riverpod(dependencies: [database])
Stream<List<PillSheetModifiedHistory>> archivedPillSheetModifiedHistories(ArchivedPillSheetModifiedHistoriesRef ref, {String? afterCursor}) {
  if (afterCursor != null) {
    return ref
        .watch(databaseProvider)
        .pillSheetModifiedHistoriesReference()
        .where(
          PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate,
          isLessThanOrEqualTo: today().add(const Duration(days: 1)),
          isGreaterThanOrEqualTo: today().subtract(const Duration(days: PillSheetModifiedHistoryServiceActionFactory.limitDays)),
        )
        .where(PillSheetModifiedHistoryFirestoreKeys.archivedDateTime, isNull: false)
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
        .startAfter([afterCursor])
        .limit(20)
        .snapshots()
        .map((reference) => reference.docs)
        .map((docs) => docs.map((doc) => doc.data()).toList());
  } else {
    return ref
        .watch(databaseProvider)
        .pillSheetModifiedHistoriesReference()
        .where(
          PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate,
          isLessThanOrEqualTo: today().add(const Duration(days: 1)),
          isGreaterThanOrEqualTo: today().subtract(const Duration(days: PillSheetModifiedHistoryServiceActionFactory.limitDays)),
        )
        .where(PillSheetModifiedHistoryFirestoreKeys.archivedDateTime, isNull: false)
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
        .limit(20)
        .snapshots()
        .map((reference) => reference.docs)
        .map((docs) => docs.map((doc) => doc.data()).toList());
  }
}

@Riverpod(dependencies: [database])
Stream<List<PillSheetModifiedHistory>> pillSheetModifiedHistoriesWithLimitProvider(PillSheetModifiedHistoriesWithLimitProviderRef ref,
    {required int limit}) {
  return ref
      .watch(databaseProvider)
      .pillSheetModifiedHistoriesReference()
      .where(
        PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate,
        isLessThanOrEqualTo: today().add(const Duration(days: 1)),
        isGreaterThanOrEqualTo: today().subtract(const Duration(days: PillSheetModifiedHistoryServiceActionFactory.limitDays)),
      )
      .where(PillSheetModifiedHistoryFirestoreKeys.archivedDateTime, isNull: true)
      .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
      .limit(limit)
      .snapshots()
      .map((reference) => reference.docs)
      .map((docs) => docs.map((doc) => doc.data()).toList());
}

final batchSetPillSheetModifiedHistoryProvider = Provider((ref) => BatchSetPillSheetModifiedHistory(ref.watch(databaseProvider)));

class BatchSetPillSheetModifiedHistory {
  final DatabaseConnection databaseConnection;
  BatchSetPillSheetModifiedHistory(this.databaseConnection);

  void call(WriteBatch batch, PillSheetModifiedHistory history) async {
    batch.set(databaseConnection.pillSheetModifiedHistoryReference(pillSheetModifiedHistoryID: null), history, SetOptions(merge: true));
  }
}

final setPillSheetModifiedHistoryProvider = Provider((ref) => SetPillSheetModifiedHistory(ref.watch(databaseProvider)));

class SetPillSheetModifiedHistory {
  final DatabaseConnection databaseConnection;
  SetPillSheetModifiedHistory(this.databaseConnection);

  Future<void> call(PillSheetModifiedHistory history) async {
    await databaseConnection.pillSheetModifiedHistoryReference(pillSheetModifiedHistoryID: history.id).set(history, SetOptions(merge: true));
  }
}
