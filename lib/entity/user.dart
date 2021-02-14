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

extension UserStatsKeys on String {
  static final beginingVersion = "beginingVersion";
}

@freezed
abstract class UserStats implements _$UserPrivate {
  UserStats._();
  factory UserStats({String beginingVersion}) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}

extension UserFirestoreFieldKeys on String {
  static final anonymouseUserID = "anonymouseUserID";
  static final settings = "settings";
  static final migratedFlutter = "migratedFlutter";
  static final packageInfo = "packageInfo";
}

@freezed
abstract class User implements _$User {
  String get documentID => anonymouseUserID;

  User._();
  factory User({
    @required String anonymouseUserID,
    @JsonKey(name: "settings") Setting setting,
    @Default(false) bool migratedFlutter,
    @JsonKey(name: "stats") UserStats stats;
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
