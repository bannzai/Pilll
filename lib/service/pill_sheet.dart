import 'package:Pilll/database/database.dart';
import 'package:Pilll/entity/firestore_timestamp_converter.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/all.dart';

abstract class PillSheetServiceInterface {
  Future<List<PillSheetModel>> fetchLatests(int limit);
  Future<PillSheetModel> register(PillSheetModel model);
  Future<void> delete(PillSheetModel pillSheet);
  Future<PillSheetModel> update(PillSheetModel pillSheet);
  Stream<List<PillSheetModel>> subscribeForLatestPillSheet();
}

final pillSheetServiceProvider = Provider<PillSheetServiceInterface>(
    (ref) => PillSheetService(ref.watch(databaseProvider)));

class PillSheetService extends PillSheetServiceInterface {
  final DatabaseConnection _database;

  PillSheetModel _mapPillSheet(QueryDocumentSnapshot snapshot) {
    assert(snapshot == null);
    if (snapshot == null) {
      return null;
    }

    var data = snapshot.data();
    data["id"] = snapshot.id;
    var pillSheetModel = PillSheetModel.fromJson(data);

    return pillSheetModel;
  }

  Query _queryOfFetchLastPillSheet(int limit) {
    return _database
        .pillSheetsReference()
        .orderBy(PillSheetFirestoreKey.createdAt)
        .limitToLast(limit);
  }

  PillSheetService(this._database);
  @override
  Future<List<PillSheetModel>> fetchLatests(int limit) {
    return _queryOfFetchLastPillSheet(limit)
        .get()
        .then((event) => event.docs.map((doc) => _mapPillSheet(doc)).toList());
  }

  @override
  Future<PillSheetModel> register(PillSheetModel model) {
    if (model.createdAt != null) throw PillSheetAlreadyExists();
    if (model.deletedAt != null) throw PillSheetAlreadyDeleted();
    final copied = model.copyWith(createdAt: DateTime.now());

    var json = copied.toJson();
    json.remove("id");
    return _database.pillSheetsReference().add(json).then((value) {
      return PillSheetModel.fromJson(json..addAll({"id": value.id}));
    });
  }

  Future<void> delete(PillSheetModel pillSheet) {
    if (pillSheet == null) throw PillSheetIsNotExists();
    return _database.pillSheetReference(pillSheet.documentID).update({
      PillSheetFirestoreKey.deletedAt:
          TimestampConverter.dateTimeToTimestamp(DateTime.now())
    });
  }

  Future<PillSheetModel> update(PillSheetModel pillSheet) {
    var json = pillSheet.toJson();
    json.remove("id");
    return _database
        .pillSheetReference(pillSheet.documentID)
        .update(json)
        .then((_) => pillSheet);
  }

  Stream<List<PillSheetModel>> subscribeForLatestPillSheet() {
    return _queryOfFetchLastPillSheet(1)
        .snapshots()
        .map((event) => event.docs.map((doc) => _mapPillSheet(doc)).toList());
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
