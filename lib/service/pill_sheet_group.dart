import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet_group.dart';

class PillSheetGroupService {
  final DatabaseConnection _database;

  PillSheetGroupService(this._database);

  Query _fetchLatestQuery() {
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
    data["id"] = document.id;

    return PillSheetGroup.fromJson(data);
  }

  Future<PillSheetGroup?> fetchLatest() async {
    final snapshot = await _fetchLatestQuery().get();
    return _map(snapshot);
  }

  Stream<PillSheetGroup> subscribeForLatestPillSheet() {
    return _fetchLatestQuery()
        .snapshots()
        .map(((event) => _map(event)))
        .skipWhile((element) => element == null)
        .cast();
  }

  // Return new PillSheet document id
  PillSheetGroup register(WriteBatch batch, PillSheetGroup pillSheetGroup) {
    if (pillSheetGroup.createdAt != null) throw PillSheetGroupAlreadyExists();
    if (pillSheetGroup.deletedAt != null) throw PillSheetGroupAlreadyDeleted();

    final copied = pillSheetGroup.copyWith(createdAt: DateTime.now());
    final newDocument = _database.pillSheetGroupsReference().doc();
    batch.set(newDocument, copied.toJson(), SetOptions(merge: true));
    return copied;
  }

  PillSheetGroup delete(WriteBatch batch, PillSheetGroup pillSheetGroup) {
    if (pillSheetGroup.deletedAt != null) throw PillSheetGroupAlreadyDeleted();

    final updated = pillSheetGroup.copyWith(deletedAt: DateTime.now());
    batch.set(_database.pillSheetGroupReference(pillSheetGroup.id!),
        updated.toJson(), SetOptions(merge: true));
    return updated;
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
