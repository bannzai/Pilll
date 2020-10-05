import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PillSheetRepositoryInterface {
  Future<PillSheetModel> current(String userID);
}

class PillSheetRepository extends PillSheetRepositoryInterface {
  String _path(String userID) {
    return "${User.path}/$userID/pill_sheets";
  }

  @override
  Future<PillSheetModel> current(String userID) {
    return FirebaseFirestore.instance
        .collection(_path(userID))
        .orderBy("createdAt")
        .limitToLast(1)
        .snapshots()
        .listen((event) {
      var document = event.docs.last;
      if (!document.exists) return null;

      var data = document.data();
      data["id"] = document.id;
      var pillSheetModel = PillSheetModel.fromJson(data);

      if (pillSheetModel.deletedAt != null) return null;
      return pillSheetModel;
    }).asFuture();
  }
}
