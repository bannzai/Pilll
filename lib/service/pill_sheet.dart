import 'package:Pilll/database/database.dart';
import 'package:Pilll/entity/firestore_timestamp_converter.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/entity/user_error.dart';
import 'package:Pilll/auth/auth.dart/';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/all.dart';

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

  PillSheetService(this._database);

  PillSheetModel _filterForLatestPillSheet(QuerySnapshot snapshot) {
    if (snapshot.docs.isEmpty) return null;
    if (!snapshot.docs.last.exists) return null;
    var document = snapshot.docs.last;

    var data = document.data();
    data["id"] = document.id;
    var pillSheetModel = PillSheetModel.fromJson(data);

    if (pillSheetModel.deletedAt != null) return null;
    return pillSheetModel;
  }

  @override
  Future<PillSheetModel> fetchLast() {
    return _database
        .pillSheetsReference()
        .orderBy(PillSheetFirestoreKey.createdAt)
        .limitToLast(1)
        .get()
        .then((event) => _filterForLatestPillSheet(event));
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
    }).catchError((error) {
      throw UserDisplayedError(
          error: error, displayedMessage: "ピルシートの登録に失敗しました。再度お試しください");
    });
  }

  Future<void> delete(PillSheetModel pillSheet) {
    if (pillSheet == null) throw PillSheetIsNotExists();
    return _database.pillSheetReference(pillSheet.documentID).update({
      PillSheetFirestoreKey.deletedAt:
          TimestampConverter.dateTimeToTimestamp(DateTime.now())
    }).catchError((error) => UserDisplayedError(
        error: error, displayedMessage: "ピルシートの削除に失敗しました。再度お試しください"));
  }

  Future<PillSheetModel> update(PillSheetModel pillSheet) {
    var json = pillSheet.toJson();
    json.remove("id");
    return _database
        .pillSheetReference(pillSheet.documentID)
        .update(json)
        .then((_) => pillSheet);
  }

  Stream<PillSheetModel> subscribeForLatestPillSheet() {
    return _database
        .pillSheetsReference()
        .snapshots()
        .map((event) => _filterForLatestPillSheet(event));
  }
}

class PillSheetIsNotExists implements Exception {
  toString() {
    return "pill sheet is not exists";
  }
}

class PillSheetAlreadyExists implements Exception {
  toString() {
    return "pill sheet already exists";
  }
}

class PillSheetAlreadyDeleted implements Exception {
  toString() {
    return "pill sheet already deleted";
  }
}
