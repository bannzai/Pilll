import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class _CollectionPath {
  static final String users = "users";
  static String pillSheets(String userID) => "$users/$userID/pill_sheets";
}

class DatabaseConnection {
  DatabaseConnection(this._userID)
      : assert(
            _userID != null, 'Pill firestore request should necessary userID');
  final String _userID;

  DocumentReference userReference() =>
      FirebaseFirestore.instance.collection(_CollectionPath.users).doc(_userID);

  CollectionReference pillSheetsReference() => FirebaseFirestore.instance
      .collection(_CollectionPath.pillSheets(_userID));

  DocumentReference pillSheetReference(String pillSheetID) =>
      FirebaseFirestore.instance
          .collection(_CollectionPath.pillSheets(_userID))
          .doc(pillSheetID);
}
