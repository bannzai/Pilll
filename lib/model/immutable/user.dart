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
  static final anonnymouseUserID = "anonnymouseUserID";
  static final settings = "settings";
}

@immutable
class User {
  static final path = "users";
  String get documentID => anonymousUserID;

  final String anonymousUserID;
  final Map<String, dynamic> settings;

  User._({this.anonymousUserID, this.settings});

  static User map(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data();
    return User._(
      anonymousUserID: data[UserPropertyKeys.anonnymouseUserID],
      settings: data[UserPropertyKeys.settings],
    );
  }

  static Future<User> fetch(UserCredential credential) {
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(credential.user.uid)
        .get()
        .then((document) {
      if (!document.exists) {
        throw UserNotFound();
      }
      return User.map(document);
    });
  }

  static Future<User> create(UserCredential credential) {
    return FirebaseFirestore.instance
        .collection(User.path)
        .add(
          {
            credential.user.uid: {
              UserPropertyKeys.anonnymouseUserID: credential.user.uid,
            },
          },
        )
        .then((documentReference) => documentReference.get())
        .then(User.map);
  }
}

extension UserInterface on User {
  static Future<User> fetchOrCreateUser(UserCredential userCredential) {
    return User.fetch(userCredential).catchError((error) {
      if (error is UserNotFound) {
        return User.create(userCredential);
      }
      throw FormatException(
          "cause exception when failed fetch and create user");
    });
  }
}
