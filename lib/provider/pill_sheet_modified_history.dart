import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pill_sheet_modified_history.g.dart';

@Riverpod()
Stream<List<PillSheetModifiedHistory>> pillSheetModifiedHistories(PillSheetModifiedHistoriesRef ref, {DateTime? afterCursor}) {
  if (afterCursor != null) {
    return ref
        .watch(databaseProvider)
        .pillSheetModifiedHistoriesReference()
        .where(
          Filter.or(
            Filter(PillSheetModifiedHistoryFirestoreKeys.isArchived, isEqualTo: false),
            // TODO: [PillSheetModifiedHistory-IsArchived] 2024-04 移行に削除。TTLで半年以上前のデータは消えるので、それ以降はisArchivedはすべての入っているのでこのisNullの条件は不要になる
            Filter(PillSheetModifiedHistoryFirestoreKeys.isArchived, isNull: true),
          ),
        )
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
          Filter.or(
            Filter(PillSheetModifiedHistoryFirestoreKeys.isArchived, isEqualTo: false),
            // TODO: [PillSheetModifiedHistory-IsArchived] 2024-04 移行に削除。TTLで半年以上前のデータは消えるので、それ以降はisArchivedはすべての入っているのでこのisNullの条件は不要になる
            Filter(PillSheetModifiedHistoryFirestoreKeys.isArchived, isNull: true),
          ),
        )
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
        .limit(20)
        .snapshots()
        .map((reference) => reference.docs)
        .map((docs) => docs.map((doc) => doc.data()).toList());
  }
}

@Riverpod()
Stream<List<PillSheetModifiedHistory>> archivedPillSheetModifiedHistories(ArchivedPillSheetModifiedHistoriesRef ref, {DateTime? afterCursor}) {
  if (afterCursor != null) {
    return ref
        .watch(databaseProvider)
        .pillSheetModifiedHistoriesReference()
        .where(PillSheetModifiedHistoryFirestoreKeys.isArchived, isEqualTo: true)
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
        .startAfter([afterCursor])
        .limit(20)
        .snapshots()
        .map((reference) => reference.docs)
        .map((docs) => docs.map((doc) => doc.data()).toList());
  } else {
    try {
      final value = ref
          .watch(databaseProvider)
          .pillSheetModifiedHistoriesReference()
          .where(PillSheetModifiedHistoryFirestoreKeys.isArchived, isEqualTo: true)
          .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
          .limit(20)
          .snapshots()
          .map((reference) => reference.docs)
          .map((docs) => docs.map((doc) => doc.data()).toList());

      value.forEach((element) {
        debugPrint("[DEBUG] element: ${element}");
      });
      return value;
    } catch (e) {
      rethrow;
    }
  }
}

@Riverpod()
Stream<List<PillSheetModifiedHistory>> pillSheetModifiedHistoriesWithLimit(PillSheetModifiedHistoriesWithLimitRef ref, {required int limit}) {
  return ref
      .watch(databaseProvider)
      .pillSheetModifiedHistoriesReference()
      .where(
        Filter.or(
          Filter(PillSheetModifiedHistoryFirestoreKeys.isArchived, isEqualTo: false),
          // TODO: [PillSheetModifiedHistory-IsArchived] 2024-04 移行に削除。TTLで半年以上前のデータは消えるので、それ以降はisArchivedはすべての入っているのでこのisNullの条件は不要になる
          Filter(PillSheetModifiedHistoryFirestoreKeys.isArchived, isNull: true),
        ),
      )
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
