import 'dart:async';

import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  static User _cache;

  final String anonymousUserID;
  String get documentID => anonymousUserID;
  final Setting setting;
  final PillSheetModel currentPillSheet;

  User._({
    @required this.anonymousUserID,
    @required this.setting,
    @required this.currentPillSheet,
  });

  static User _map(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data();
    return User._(
      anonymousUserID: data[UserFirestoreFieldKeys.anonymouseUserID],
      setting: Setting(data[UserFirestoreFieldKeys.settings]),
      currentPillSheet:
          PillSheetModel(data[UserFirestoreFieldKeys.currentPillSheet]),
    );
  }

  static User user() {
    if (_cache == null) throw UserNotFound();
    return _cache;
  }

  static Future<User> fetch() {
    if (_cache != null) {
      return Future.value(_cache);
    }
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((document) {
      if (!document.exists) {
        throw UserNotFound();
      }
      var user = User._map(document);
      assert(_cache == null);
      _cache = user;
      return user;
    });
  }

  DocumentReference documentReference() {
    return FirebaseFirestore.instance.collection(User.path).doc(documentID);
  }

  static Future<User> create() {
    return fetch().then((user) {
      return user.documentReference().set(
        {
          UserFirestoreFieldKeys.anonymouseUserID:
              FirebaseAuth.instance.currentUser.uid,
        },
      );
    }).then((_) {
      return user();
    });
  }
}

extension UserInterface on User {
  static Future<User> fetchOrCreateUser() {
    return User.fetch().catchError((error) {
      if (error is UserNotFound) {
        return User.create();
      }
      throw FormatException(
          "cause exception when failed fetch and create user for $error");
    });
  }
}
