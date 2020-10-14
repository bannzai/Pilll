import 'package:Pilll/model/setting.dart';
import 'package:Pilll/service/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/all.dart';

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

// ignore: top_level_function_literal_block
final userSettingProvider = FutureProvider((ref) async {
  final user = await ref.watch(initialUserProvider.future);
  return user.setting;
});

extension UserFirestoreFieldKeys on String {
  static final anonymouseUserID = "anonymouseUserID";
  static final settings = "settings";
}

@freezed
abstract class User implements _$User {
  String get documentID => anonymousUserID;

  User._();
  factory User({@required String anonymousUserID, Setting setting}) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
