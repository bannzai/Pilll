import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class UserNotFound implements Exception {
  toString() {
    return "user not found";
  }
}

extension UserPropertyKeys on String {
  static final anonymouseUserID = "anonymouseUserID";
  static final settings = "settings";
}

class User {
  static final path = "users";
  String get documentID => anonymousUserID;

  final String anonymousUserID;
  Map<String, dynamic> settings;

  User._({this.anonymousUserID, this.settings});

  static User _map(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data();
    return User._(
      anonymousUserID: data[UserPropertyKeys.anonymouseUserID],
      settings: data[UserPropertyKeys.settings],
    );
  }

  static Future<User> fetch() {
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

  static Future<User> create() {
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set(
      {
        UserPropertyKeys.anonymouseUserID:
            FirebaseAuth.instance.currentUser.uid,
      },
    ).then((_) {
      return User.fetch();
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

  Future<void> setSettings(Map<String, dynamic> settings) {
    return FirebaseFirestore.instance.collection(User.path).doc(documentID).set(
        {UserPropertyKeys.settings: settings},
        SetOptions(merge: true)).then((_) => this.settings = settings);
  }
}
