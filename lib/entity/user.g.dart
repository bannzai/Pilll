// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserPrivate _$_$_UserPrivateFromJson(Map<String, dynamic> json) {
  return _$_UserPrivate(
    fcmToken: json['fcmToken'] as String,
  );
}

Map<String, dynamic> _$_$_UserPrivateToJson(_$_UserPrivate instance) =>
    <String, dynamic>{
      'fcmToken': instance.fcmToken,
    };

_$_User _$_$_UserFromJson(Map<String, dynamic> json) {
  return _$_User(
    anonymouseUserID: json['anonymouseUserID'] as String,
    setting: json['settings'] == null
        ? null
        : Setting.fromJson(json['settings'] as Map<String, dynamic>),
    createdAt:
        TimestampConverter.timestampToDateTime(json['createdAt'] as Timestamp),
  );
}

Map<String, dynamic> _$_$_UserToJson(_$_User instance) => <String, dynamic>{
      'anonymouseUserID': instance.anonymouseUserID,
      'settings': instance.setting,
      'createdAt': TimestampConverter.dateTimeToTimestamp(instance.createdAt),
    };
