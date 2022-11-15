import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetGroupDatastoreProvider = Provider<PillSheetGroupDatastore>((ref) => PillSheetGroupDatastore(ref.watch(databaseProvider)));

class PillSheetGroupDatastore {
  final DatabaseConnection _database;

  PillSheetGroupDatastore(this._database);

  Future<PillSheetGroup?> fetchLatest() async {
    final snapshot = await _latestQuery().get();
    return _filter(snapshot);
  }

  Future<PillSheetGroup?> fetchBeforePillSheetGroup() async {
    final snapshot = await _database.pillSheetGroupsReference().orderBy(PillSheetGroupFirestoreKeys.createdAt).limitToLast(2).get();
    if (snapshot.docs.length <= 1) {
      return null;
    }

    return snapshot.docs[0].data();
  }

  // Return new PillSheet document id
  PillSheetGroup register(WriteBatch batch, PillSheetGroup pillSheetGroup) {
    if (pillSheetGroup.deletedAt != null) throw PillSheetGroupAlreadyDeleted();

    final copied = pillSheetGroup.copyWith(createdAt: DateTime.now());
    final newDocument = _database.pillSheetGroupsReference().doc();
    batch.set(newDocument, copied, SetOptions(merge: true));
    return copied.copyWith(id: newDocument.id);
  }

  PillSheetGroup delete(WriteBatch batch, PillSheetGroup pillSheetGroup) {
    if (pillSheetGroup.deletedAt != null) throw PillSheetGroupAlreadyDeleted();

    final updated = pillSheetGroup.copyWith(deletedAt: DateTime.now());
    batch.set(_database.pillSheetGroupReference(pillSheetGroup.id!), updated, SetOptions(merge: true));
    return updated;
  }

  Future<void> update(PillSheetGroup pillSheetGroup) async {
    await _database.pillSheetGroupReference(pillSheetGroup.id!).set(pillSheetGroup, SetOptions(merge: true));
  }

  void updateWithBatch(WriteBatch batch, PillSheetGroup pillSheetGroup) {
    batch.set(_database.pillSheetGroupReference(pillSheetGroup.id!), pillSheetGroup, SetOptions(merge: true));
  }
}

class PillSheetGroupAlreadyExists extends Error {
  @override
  toString() {
    return "ピルシートグループがすでに存在しています。";
  }
}

class PillSheetGroupAlreadyDeleted extends Error {
  @override
  String toString() {
    return "ピルシートグループはすでに削除されています。";
  }
}
