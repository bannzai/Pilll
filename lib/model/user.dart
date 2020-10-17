import 'package:Pilll/model/setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'user.g.dart';
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
  String get documentID => anonymouseUserID;

  User._();
  factory User(
      {@required String anonymouseUserID,
      @JsonKey(name: "settings") Setting setting}) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
