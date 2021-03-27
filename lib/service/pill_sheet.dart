import 'package:pilll/database/database.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

abstract class PillSheetServiceInterface {
  Future<PillSheetModel> fetchLast();
  Future<PillSheetModel> register(PillSheetModel model);
  Future<void> delete(PillSheetModel pillSheet);
  Future<PillSheetModel> update(PillSheetModel pillSheet);
  Stream<PillSheetModel> subscribeForLatestPillSheet();
}

final pillSheetServiceProvider = Provider<PillSheetServiceInterface>(
    (ref) => PillSheetService(ref.watch(databaseProvider)));

class PillSheetService extends PillSheetServiceInterface {
  final DatabaseConnection _database;

  PillSheetModel? _filterForLatestPillSheet(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) return null;
    if (!snapshot.docs.last.exists) return null;
    var document = snapshot.docs.last;

    var data = document.data()!;
    data["id"] = document.id;
    var pillSheetModel = PillSheetModel.fromJson(data);

    return pillSheetModel;
  }

  Query _queryOfFetchLastPillSheet() {
    return _database
        .pillSheetsReference()
        .orderBy(PillSheetFirestoreKey.createdAt)
        .limitToLast(1);
  }

  PillSheetService(this._database);
  @override
  Future<PillSheetModel> fetchLast() {
    return _queryOfFetchLastPillSheet()
        .get()
        .then((event) => _filterForLatestPillSheet(event)!);
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
    return _database.pillSheetReference(pillSheet.documentID!).update({
      PillSheetFirestoreKey.deletedAt:
          TimestampConverter.dateTimeToTimestamp(DateTime.now())
    });
  }

  Future<PillSheetModel> update(PillSheetModel pillSheet) {
    var json = pillSheet.toJson();
    json.remove("id");
    return _database
        .pillSheetReference(pillSheet.documentID!)
        .update(json)
        .then((_) => pillSheet);
  }

  Stream<PillSheetModel> subscribeForLatestPillSheet() {
    return _queryOfFetchLastPillSheet()
        .snapshots()
        .map(((event) => _filterForLatestPillSheet(event)))
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
