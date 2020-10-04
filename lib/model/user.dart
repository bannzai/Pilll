import 'dart:async';

import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class UserNotFound implements Exception {
  toString() {
    return "user not found";
  }
}

extension UserFirestoreFieldKeys on String {
  static final anonymouseUserID = "anonymouseUserID";
  static final settings = "settings";
  static final currentPillSheet = "pillSheet";
}

class User {
  static final path = "users";

  final String anonymousUserID;
  String get documentID => anonymousUserID;
  Setting setting;
  PillSheetModel currentPillSheet;

  User._({
    @required this.anonymousUserID,
    @required this.setting,
    @required this.currentPillSheet,
  });

  static User map(Map<String, dynamic> firestoreDocumentData) {
    return User._(
      anonymousUserID:
          firestoreDocumentData[UserFirestoreFieldKeys.anonymouseUserID],
      setting: firestoreDocumentData[UserFirestoreFieldKeys.settings] != null
          ? Setting.fromJson(
              firestoreDocumentData[UserFirestoreFieldKeys.settings],
            )
          : null,
      currentPillSheet:
          firestoreDocumentData[UserFirestoreFieldKeys.currentPillSheet] != null
              ? PillSheetModel.fromJson(
                  firestoreDocumentData[
                      UserFirestoreFieldKeys.currentPillSheet],
                )
              : null,
    );
  }

  DocumentReference documentReference() {
    return FirebaseFirestore.instance.collection(User.path).doc(documentID);
  }

  Future<void> deleteCurrentPillSheet() {
    return FirebaseFirestore.instance.collection(User.path).doc(documentID).set(
      {
        UserFirestoreFieldKeys.currentPillSheet: null,
      },
      SetOptions(merge: true),
    ).then((_) => this.currentPillSheet = null);
  }
}
