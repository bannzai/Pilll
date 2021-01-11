import 'package:Pilll/database/database.dart';
import 'package:Pilll/entity/firestore_timestamp_converter.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/entity/user.dart';
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
  @override
  Future<PillSheetModel> fetchLast() {
    return _database
        .userReference()
        .get()
        .then((value) => User.fromJson(value.data()))
        .then((user) => user.latestPillSheet);
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

  Stream<PillSheetModel> subscribeForLatestPillSheet() {
    return _database
        .userReference()
        .snapshots()
        .map((event) => User.fromJson(event.data()).latestPillSheet);
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
