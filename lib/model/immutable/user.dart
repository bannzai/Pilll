import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
class User {
  static final path = "users";
  String get documentID => anonymousUserID;

  final String anonymousUserID;

  User._({this.anonymousUserID});

  static Future<User> fetch(UserCredential credential) {
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(credential.user.uid)
        .get()
        .then((data) => data.data())
        .then((dic) {
      return User._(anonymousUserID: dic["anonymousUserID"]);
    });
  }
}
