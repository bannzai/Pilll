// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$_$_UserFromJson(Map<String, dynamic> json) {
  return _$_User(
    anonymousUserID: json['anonymousUserID'] as String,
    setting: json['setting'] == null
        ? null
        : Setting.fromJson(json['setting'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_UserToJson(_$_User instance) => <String, dynamic>{
      'anonymousUserID': instance.anonymousUserID,
      'setting': instance.setting,
    };
