import 'package:Pilll/model/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class UserNotFound implements Exception {
  toString() {
    return "user not found";
  }
}

class UserAlreadyExists implements Exception {
  toString() {
    return "user already exists";
  }
}

extension UserFirestoreFieldKeys on String {
  static final anonymouseUserID = "anonymouseUserID";
  static final settings = "settings";
}

class User {
  static final path = "users";

  final String anonymousUserID;
  String get documentID => anonymousUserID;
  final Setting setting;

  User._({
    @required this.anonymousUserID,
    @required this.setting,
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
    );
  }
}
