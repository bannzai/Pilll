import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotFound implements Exception {
  toString() {
    return "user not found";
  }
}

extension UserPropertyKeys on String {
  static final anonymouseUserID = "anonymouseUserID";
  static final settings = "settings";
}

@immutable
class User {
  static final path = "users";
  String get documentID => anonymousUserID;

  final String anonymousUserID;
  final Map<String, dynamic> settings;

  User._({this.anonymousUserID, this.settings});

  static User _map(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data();
    return User._(
      anonymousUserID: data[UserPropertyKeys.anonymouseUserID],
      settings: data[UserPropertyKeys.settings],
    );
  }

  static Future<User> _fetch() {
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((document) {
      if (!document.exists) {
        throw UserNotFound();
      }
      return User._map(document);
    });
  }

  static Future<User> _create() {
    return FirebaseFirestore.instance
        .collection(User.path)
        .add(
          {
            FirebaseAuth.instance.currentUser.uid: {
              UserPropertyKeys.anonymouseUserID:
                  FirebaseAuth.instance.currentUser.uid,
            },
          },
        )
        .then((documentReference) => documentReference.get())
        .then(User._map);
  }
}

extension UserInterface on User {
  static Future<User> fetchOrCreateUser() {
    return User._fetch().catchError((error) {
      if (error is UserNotFound) {
        return User._create();
      }
      throw FormatException(
          "cause exception when failed fetch and create user");
    });
  }

  Future<void> setSettings(Map<String, dynamic> settings) {
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(documentID)
        .set({UserPropertyKeys.settings: settings});
  }
}
