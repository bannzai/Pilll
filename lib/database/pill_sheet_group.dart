import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetGroupDatabaseProvider = Provider<PillSheetGroupDatabase>(
    (ref) => PillSheetGroupDatabase(ref.watch(databaseProvider)));

class PillSheetGroupDatabase {
  final DatabaseConnection _database;

  PillSheetGroupDatabase(this._database);

  Query _latestQuery() {
    return _database
        .pillSheetGroupsReference()
        .orderBy(PillSheetGroupFirestoreKeys.createdAt)
        .limitToLast(1);
  }

  PillSheetGroup? _map(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) return null;
    if (!snapshot.docs.last.exists) return null;

    final document = snapshot.docs.last;
    final data = document.data() as Map<String, dynamic>;
    data.putIfAbsent("id", () => document.id);

    return PillSheetGroup.fromJson(data);
  }

  Future<PillSheetGroup?> fetchLatest() async {
    final snapshot = await _latestQuery().get();
    return _map(snapshot);
  }

  Future<PillSheetGroup?> fetchBeforePillSheetGroup() async {
    final snapshot = await _database
        .pillSheetGroupsReference()
        .orderBy(PillSheetGroupFirestoreKeys.createdAt)
        .limitToLast(2)
        .get();
    if (snapshot.docs.length <= 1) {
      return null;
    }

    final document = snapshot.docs[0];
    final data = document.data() as Map<String, dynamic>;
    data.putIfAbsent("id", () => document.id);

    return PillSheetGroup.fromJson(data);
  }

  Stream<PillSheetGroup> streamForLatest() {
    return _latestQuery()
        .snapshots()
        .map(((event) => _map(event)))
        .where((event) => event != null)
        .cast();
  }

  // Return new PillSheet document id
  PillSheetGroup register(WriteBatch batch, PillSheetGroup pillSheetGroup) {
    if (pillSheetGroup.deletedAt != null) throw PillSheetGroupAlreadyDeleted();

    final copied = pillSheetGroup.copyWith(createdAt: DateTime.now());
    final newDocument = _database.pillSheetGroupsReference().doc();
    batch.set(newDocument, copied.toJson(), SetOptions(merge: true));
    return copied.copyWith(id: newDocument.id);
  }

  PillSheetGroup delete(WriteBatch batch, PillSheetGroup pillSheetGroup) {
    if (pillSheetGroup.deletedAt != null) throw PillSheetGroupAlreadyDeleted();

    final updated = pillSheetGroup.copyWith(deletedAt: DateTime.now());
    batch.set(_database.pillSheetGroupReference(pillSheetGroup.id!),
        updated.toJson(), SetOptions(merge: true));
    return updated;
  }

  Future<void> update(PillSheetGroup pillSheetGroup) async {
    await _database
        .pillSheetGroupReference(pillSheetGroup.id!)
        .update(pillSheetGroup.toJson());
  }

  void updateWithBatch(WriteBatch batch, PillSheetGroup pillSheetGroup) {
    final json = pillSheetGroup.toJson();
    batch.update(_database.pillSheetGroupReference(pillSheetGroup.id!), json);
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
