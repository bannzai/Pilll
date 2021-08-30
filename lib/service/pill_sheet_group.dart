import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/pill_sheet_group.dart';

class PillSheetGroupService {
  final DatabaseConnection _database;

  PillSheetGroupService(this._database);

  Query _fetchLatestQuery() {
    return _database
        .pillSheetsReference()
        .orderBy(PillSheetGroupFirestoreKeys.createdAt)
        .limitToLast(1);
  }

  PillSheetGroup? _filter(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) return null;
    if (!snapshot.docs.last.exists) return null;
    final document = snapshot.docs.last;
    return PillSheetGroup.fromJson(document.data() as Map<String, dynamic>);
  }

  Future<PillSheetGroup?> fetchLatest() async {
    final snapshot = await _fetchLatestQuery().get();
    return _filter(snapshot);
  }

  Stream<PillSheetGroup> subscribeForLatestPillSheet() {
    return _fetchLatestQuery()
        .snapshots()
        .map(((event) => _filter(event)))
        .skipWhile((element) => element == null)
        .cast();
  }

  // Return new PillSheet document id
  PillSheetGroup register(WriteBatch batch, PillSheetGroup pillSheetGroup) {
    if (pillSheetGroup.createdAt != null) throw PillSheetGroupAlreadyExists();
    if (pillSheetGroup.deletedAt != null) throw PillSheetGroupAlreadyDeleted();
    final copied = pillSheetGroup.copyWith(createdAt: DateTime.now());
    final newDocument = _database.pillSheetsReference().doc();
    batch.set(newDocument, copied.toJson(), SetOptions(merge: true));
    return copied;
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
