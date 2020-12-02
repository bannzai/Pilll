import 'package:Pilll/entity/firestore_timestamp_converter.dart';
import 'package:Pilll/entity/setting.dart';
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

extension UserPrivateFirestoreFieldKeys on String {
  static final fcmToken = 'fcmToken';
  static final id = 'id';
}

@freezed
abstract class UserPrivate implements _$UserPrivate {
  UserPrivate._();
  factory UserPrivate({String fcmToken}) = _UserPrivate;
  factory UserPrivate.create({@required String fcmToken}) =>
      UserPrivate(fcmToken: fcmToken);

  factory UserPrivate.fromJson(Map<String, dynamic> json) =>
      _$UserPrivateFromJson(json);
}

extension UserFirestoreFieldKeys on String {
  static final anonymouseUserID = "anonymouseUserID";
  static final settings = "settings";
  static final createdAt = "createdAt";
}

@freezed
abstract class User implements _$User {
  String get documentID => anonymouseUserID;
  String get privateDocumentID =>
      documentID + "_${createdAt.toUtc().millisecondsSinceEpoch}";

  User._();
  factory User({
    @required
        String anonymouseUserID,
    @JsonKey(name: "settings")
        Setting setting,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    @required
        DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
