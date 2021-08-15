import 'package:pilll/database/database.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetServiceProvider = Provider<PillSheetService>(
    (ref) => PillSheetService(ref.watch(databaseProvider)));

class PillSheetService {
  final DatabaseConnection _database;

  PillSheet? _filterForLatestPillSheet(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) return null;
    if (!snapshot.docs.last.exists) return null;
    var document = snapshot.docs.last;

    return _mapToEntity(document);
  }

  PillSheet _mapToEntity(QueryDocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    data["id"] = snapshot.id;
    return PillSheet.fromJson(data);
  }

  Query _queryOfFetchLastPillSheet() {
    return _database
        .pillSheetsReference()
        .orderBy(PillSheetFirestoreKey.createdAt)
        .limitToLast(1);
  }

  PillSheetService(this._database);
  Future<PillSheet?> fetchLast() {
    return _queryOfFetchLastPillSheet()
        .get()
        .then((event) => _filterForLatestPillSheet(event));
  }

  Future<List<PillSheet>> fetchListWithMax(int number) {
    return _database
        .pillSheetsReference()
        .limit(number)
        .get()
        .then((event) => event.docs.map((e) => _mapToEntity(e)).toList());
  }

  Future<List<PillSheet>> fetchAll() {
    return _database
        .pillSheetsReference()
        .get()
        .then((event) => event.docs.map((e) => _mapToEntity(e)).toList());
  }

  Transaction registerTransaction(Transaction transaction, PillSheet model) {
    if (model.createdAt != null) throw PillSheetAlreadyExists();
    if (model.deletedAt != null) throw PillSheetAlreadyDeleted();
    final copied = model.copyWith(createdAt: DateTime.now());

    var json = copied.toJson();
    json.remove("id");
    return transaction.set(
        _database.pillSheetsReference().doc(), json, SetOptions(merge: true));
  }

  Future<void> delete(PillSheet pillSheet) {
    return _database.pillSheetReference(pillSheet.documentID!).update({
      PillSheetFirestoreKey.deletedAt:
          TimestampConverter.dateTimeToTimestamp(DateTime.now())
    });
  }

  Future<PillSheet> update(PillSheet pillSheet) {
    var json = pillSheet.toJson();
    json.remove("id");
    return _database
        .pillSheetReference(pillSheet.documentID!)
        .update(json)
        .then((_) => pillSheet);
  }

  Stream<PillSheet> subscribeForLatestPillSheet() {
    return _queryOfFetchLastPillSheet()
        .snapshots()
        .map(((event) => _filterForLatestPillSheet(event)))
        .skipWhile((element) => element == null)
        .cast();
  }
}

class PillSheetIsNotExists extends Error {
  @override
  toString() {
    return "ピルシートが存在しません。";
  }
}

class PillSheetAlreadyExists extends Error {
  @override
  toString() {
    return "ピルシートがすでに存在しています。";
  }
}

class PillSheetAlreadyDeleted extends Error {
  @override
  String toString() {
    return "ピルシートはすでに削除されています。";
  }
}
