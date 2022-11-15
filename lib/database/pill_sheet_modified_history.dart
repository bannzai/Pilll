import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetModifiedHistoryDatastoreProvider =
    Provider<PillSheetModifiedHistoryDatastore>((ref) => PillSheetModifiedHistoryDatastore(ref.watch(databaseProvider)));

final pillSheetModifiedHistoryStreamForLatest7 = StreamProvider((ref) => ref.watch(pillSheetModifiedHistoryDatastoreProvider).stream(7));

class PillSheetModifiedHistoryDatastore {
  final DatabaseConnection _database;

  PillSheetModifiedHistoryDatastore(this._database);

  Future<List<PillSheetModifiedHistory>> fetchList(DateTime? after, int limit) {
    return _database
        .pillSheetModifiedHistoriesReference()
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
        .startAfter([after])
        .limit(limit)
        .get()
        .then((reference) => reference.docs.map((e) => e.data()).toList());
  }

  Future<List<PillSheetModifiedHistory>> fetchAll() {
    return _database
        .pillSheetModifiedHistoriesReference()
        .get()
        .then((reference) => reference.docs)
        .then((docs) => docs.map((doc) => doc.data()).toList());
  }

  Future<void> update(PillSheetModifiedHistory pillSheetModifiedHistory) async {
    await _database.pillSheetModifiedHistoriesReference().doc(pillSheetModifiedHistory.id).set(pillSheetModifiedHistory, SetOptions(merge: true));
  }

  Stream<List<PillSheetModifiedHistory>> stream(int limit) {
    return _database
        .pillSheetModifiedHistoriesReference()
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
        .limit(limit)
        .snapshots()
        .map((reference) => reference.docs)
        .map((docs) => docs.map((doc) => doc.data()).toList());
  }

  void add(WriteBatch batch, PillSheetModifiedHistory history) {
    batch.set(_database.pillSheetModifiedHistoriesReference().doc(), history, SetOptions(merge: true));
  }
}
