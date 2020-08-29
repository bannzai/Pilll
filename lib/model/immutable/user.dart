import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class UserNotFound implements Exception {
  toString() {
    return "user not found";
  }
}

@immutable
class User {
  static final path = "users";
  String get documentID => anonymousUserID;

  final String anonymousUserID;
  final Map<String, dynamic> settings;

  User._({this.anonymousUserID, this.settings});

  static Future<User> fetch(UserCredential credential) {
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(credential.user.uid)
        .get()
        .then((data) {
      if (!data.exists) {
        throw UserNotFound();
      }
      return data.data();
    }).then((dic) {
      return User._(
        anonymousUserID: dic["anonymousUserID"],
        settings: dic["settings"],
      );
    });
  }
}
