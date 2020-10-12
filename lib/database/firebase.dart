import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class DatabaseConnectionCollectionPath {
  static final String users = "users";
  static String pillSheets(String userID) => "$users/$userID/pill_sheets";
}

class DatabaseConnection {
  DatabaseConnection({@required this.userID})
      : assert(
            userID != null, 'Pill firestore request should necessary userID');
  final String userID;

  DocumentReference userReference() => FirebaseFirestore.instance
      .collection(DatabaseConnectionCollectionPath.users)
      .doc(userID);

  CollectionReference pillSheetsReference() => FirebaseFirestore.instance
      .collection(DatabaseConnectionCollectionPath.pillSheets(userID));

  DocumentReference pillSheetReference(String pillSheetID) =>
      FirebaseFirestore.instance
          .collection(DatabaseConnectionCollectionPath.pillSheets(userID))
          .doc(pillSheetID);
}
