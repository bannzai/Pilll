import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PillSheetRepositoryInterface {
  Future<PillSheetModel> fetchLast(String userID);
  Future<void> register(String userID, PillSheetModel model);
  Future<void> delete(String userID, PillSheetModel pillSheet);
  Future<PillSheetModel> drink(
      String userID, PillSheetModel pillSheet, DateTime takenDate);
}

class PillSheetRepository extends PillSheetRepositoryInterface {
  String _path(String userID) {
    return "${User.path}/$userID/pill_sheets";
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
        .update({PillSheetFirestoreKey.deletedAt: DateTime.now()});
  }

  Future<PillSheetModel> drink(
      String userID, PillSheetModel pillSheet, DateTime takenDate) {
    return FirebaseFirestore.instance
        .collection(_path(userID))
        .doc(pillSheet.documentID)
        .update({PillSheetFirestoreKey.lastTakenDate: takenDate}).then(
            (_) => pillSheet..lastTakenDate = takenDate);
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

final PillSheetRepositoryInterface pillSheetRepository = PillSheetRepository();
