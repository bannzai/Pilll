import 'package:Pilll/database/database.dart';
import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/firestore_timestamp_converter.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/provider/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/all.dart';

abstract class PillSheetServiceInterface {
  Future<PillSheetModel> fetchLast();
  Future<void> register(String userID, PillSheetModel model);
  Future<void> delete(String userID, PillSheetModel pillSheet);
  Future<PillSheetModel> take(
      String userID, PillSheetModel pillSheet, DateTime takenDate);
  Future<void> modifyType(PillSheetModel pillSheet, PillSheetType type);
  Future<void> modifyBeginingDate(
      PillSheetModel pillSheet, DateTime beginingDate);
}

final pillSheetServiceProvider = Provider((ref) => PIllSheetService(ref.read));
final fetchLastPillSheetProvider =
    FutureProvider((ref) => ref.watch(pillSheetServiceProvider).fetchLast());

class PIllSheetService extends PillSheetServiceInterface {
  final Reader reader;
  PIllSheetService(this.reader);

  DatabaseConnection get _database => reader(databaseProvider);

  @override
  Future<PillSheetModel> fetchLast() {
    return _database
        .pillSheetsReference()
        .orderBy(PillSheetFirestoreKey.createdAt)
        .limitToLast(1)
        .get()
        .then((event) {
      if (event.docs.isEmpty) return null;
      if (!event.docs.last.exists) return null;
      var document = event.docs.last;

      var data = document.data();
      data["id"] = document.id;
      var pillSheetModel = PillSheetModel.fromJson(data);

      if (pillSheetModel.deletedAt != null) return null;
      return pillSheetModel;
    });
  }

  @override
  Future<void> register(String userID, PillSheetModel model) {
    if (model.createdAt != null) throw PillSheetAlreadyExists();
    if (model.deletedAt != null) throw PillSheetAlreadyDeleted();
    model.createdAt = DateTime.now();

    var json = model.toJson();
    json.remove("id");
    return _database.pillSheetsReference().add(json);
  }

  Future<void> delete(String userID, PillSheetModel pillSheet) {
    return _database.pillSheetReference(pillSheet.documentID).update({
      PillSheetFirestoreKey.deletedAt:
          TimestampConverter.dateTimeToTimestamp(DateTime.now())
    });
  }

  Future<PillSheetModel> take(
      String userID, PillSheetModel pillSheet, DateTime takenDate) {
    return _database
        .pillSheetReference(pillSheet.documentID)
        .update({PillSheetFirestoreKey.lastTakenDate: takenDate}).then(
            (_) => pillSheet..lastTakenDate = takenDate);
  }

  Future<void> modifyType(PillSheetModel pillSheet, PillSheetType type) {
    var pillSheetRef = _database.pillSheetReference(pillSheet.documentID);
    var userRef = _database.userReference();
    var setting = AppState.shared.user.setting
      ..pillSheetTypeRawPath = type.rawPath;
    return _database.transaction((transaction) {
      transaction.update(pillSheetRef, {
        PillSheetFirestoreKey.typeInfo: type.typeInfo.toJson(),
      });
      transaction.update(userRef, {
        UserFirestoreFieldKeys.settings: setting.toJson(),
      });
      return;
    });
  }

  Future<void> modifyBeginingDate(
      PillSheetModel pillSheet, DateTime beginingDate) {
    return _database.pillSheetReference(pillSheet.documentID).update(
      {
        PillSheetFirestoreKey.beginingDate:
            TimestampConverter.dateTimeToTimestamp(beginingDate)
      },
    );
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

PillSheetServiceInterface pillSheetRepository = PIllSheetService(null);
