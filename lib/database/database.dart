import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

abstract class CollectionPath {
  static final String users = "users";
  static String pillSheets(String userID) => "$users/$userID/pill_sheets";
}

class Connection {
  Connection({@required this.userID})
      : assert(
            userID != null, 'Pill firestore request should necessary userID');
  final String userID;

  DocumentReference userReference() =>
      FirebaseFirestore.instance.collection(CollectionPath.users).doc(userID);

  CollectionReference pillSheetsReference() =>
      FirebaseFirestore.instance.collection(CollectionPath.pillSheets(userID));

  DocumentReference pillSheetReference(String pillSheetID) =>
      FirebaseFirestore.instance
          .collection(CollectionPath.pillSheets(userID))
          .doc(pillSheetID);
}
