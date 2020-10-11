import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/firestore_timestamp_converter.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PillSheetRepositoryInterface {
  Future<PillSheetModel> fetchLast(String userID);
  Future<void> register(String userID, PillSheetModel model);
  Future<void> delete(String userID, PillSheetModel pillSheet);
  Future<PillSheetModel> take(
      String userID, PillSheetModel pillSheet, DateTime takenDate);
  Future<void> modifyType(PillSheetModel pillSheet, PillSheetType type);
  Future<void> modifyBeginingDate(
      PillSheetModel pillSheet, DateTime beginingDate);
}

class PillSheetRepository extends PillSheetRepositoryInterface {
  String _path(String userID) {
    return "${User.path}/$userID/pill_sheets";
  }

  DocumentReference _reference(PillSheetModel pillSheet) {
    return FirebaseFirestore.instance
        .collection(_path(AppState.shared.user.documentID))
        .doc(pillSheet.documentID);
  }

  @override
  Future<PillSheetModel> fetchLast(String userID) {
    return FirebaseFirestore.instance
        .collection(_path(userID))
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
    return FirebaseFirestore.instance.collection(_path(userID)).add(json);
  }

  Future<void> delete(String userID, PillSheetModel pillSheet) {
    return FirebaseFirestore.instance
        .collection(_path(userID))
        .doc(pillSheet.documentID)
        .update({
      PillSheetFirestoreKey.deletedAt:
          TimestampConverter.dateTimeToTimestamp(DateTime.now())
    });
  }

  Future<PillSheetModel> take(
      String userID, PillSheetModel pillSheet, DateTime takenDate) {
    return FirebaseFirestore.instance
        .collection(_path(userID))
        .doc(pillSheet.documentID)
        .update({PillSheetFirestoreKey.lastTakenDate: takenDate}).then(
            (_) => pillSheet..lastTakenDate = takenDate);
  }

  Future<void> modifyType(PillSheetModel pillSheet, PillSheetType type) {
    var pillSheetRef = FirebaseFirestore.instance
        .collection(_path(AppState.shared.user.documentID))
        .doc(pillSheet.documentID);
    var userRef = FirebaseFirestore.instance
        .collection(User.path)
        .doc(AppState.shared.user.documentID);
    var setting = AppState.shared.user.setting
      ..pillSheetTypeRawPath = type.rawPath;
    return FirebaseFirestore.instance.runTransaction((transaction) {
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
    return _reference(pillSheet).update(
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

PillSheetRepositoryInterface pillSheetRepository = PillSheetRepository();

abstract class Executor {}
