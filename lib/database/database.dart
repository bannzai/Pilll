import 'package:cloud_firestore/cloud_firestore.dart';

abstract class _CollectionPath {
  static final String users = "users";
  static String pillSheets(String userID) => "$users/$userID/pill_sheets";
  static String diaries(String userID) => "$users/$userID/diaries";
}

class DatabaseConnection {
  DatabaseConnection(this._userID)
      : assert(
            _userID != null, 'Pill firestore request should necessary userID');
  final String _userID;

  DocumentReference userReference() {
    return FirebaseFirestore.instance
        .collection(_CollectionPath.users)
        .doc(_userID);
  }

  CollectionReference pillSheetsReference() => FirebaseFirestore.instance
      .collection(_CollectionPath.pillSheets(_userID));

  DocumentReference pillSheetReference(String pillSheetID) =>
      FirebaseFirestore.instance
          .collection(_CollectionPath.pillSheets(_userID))
          .doc(pillSheetID);

  CollectionReference diariesReference() =>
      FirebaseFirestore.instance.collection(_CollectionPath.diaries(_userID));

  Future<T> transaction<T>(TransactionHandler<T> transactionHandler) {
    return FirebaseFirestore.instance.runTransaction(transactionHandler);
  }
}
