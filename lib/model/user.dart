import 'package:Pilll/model/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'user.freezed.dart';

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

@freezed
abstract class User implements _$User {
  String get documentID => anonymousUserID;

  factory User({
    @required String anonymousUserID,
  }) = _User;
}
