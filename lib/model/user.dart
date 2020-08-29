import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

@immutable
class User {
  final String documentID;

  factory User({UserCredential credential}) {
    return User._(documentID: credential.user.uid);
  }
  User._({this.documentID});
}
