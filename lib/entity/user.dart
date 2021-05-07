import 'package:pilll/entity/setting.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
  factory UserPrivate({String? fcmToken}) = _UserPrivate;
  factory UserPrivate.create({required String fcmToken}) =>
      UserPrivate(fcmToken: fcmToken);

  factory UserPrivate.fromJson(Map<String, dynamic> json) =>
      _$UserPrivateFromJson(json);
}

extension UserFirestoreFieldKeys on String {
  static final anonymousUserID = "anonymousUserID";
  static final settings = "settings";
  static final migratedFlutter = "migratedFlutter";
  static final packageInfo = "packageInfo";
  static final isLinkedApple = "isLinkedApple";
  static final isLinkedGoogle = "isLinkedGoogle";
  static final appleEmail = 'appleEmail';
  static final googleEmail = 'googleEmail';
}

@freezed
abstract class User implements _$User {
  User._();
  factory User({
    @JsonKey(name: "settings") Setting? setting,
    @Default(false) bool migratedFlutter,
    @Default(false) bool isLinkedApple,
    @Default(false) bool isLinkedGoogle,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

enum LinkAccountType { apple, google }
