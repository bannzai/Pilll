// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_notification_schedule_id.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LocalNotificationScheduleID _$$_LocalNotificationScheduleIDFromJson(
        Map<String, dynamic> json) =>
    _$_LocalNotificationScheduleID(
      key: json['key'] as String,
      localNotificationID: json['localNotificationID'] as int,
      scheduleDateTime: DateTime.parse(json['scheduleDateTime'] as String),
    );

Map<String, dynamic> _$$_LocalNotificationScheduleIDToJson(
        _$_LocalNotificationScheduleID instance) =>
    <String, dynamic>{
      'key': instance.key,
      'localNotificationID': instance.localNotificationID,
      'scheduleDateTime': instance.scheduleDateTime.toIso8601String(),
    };

_$_LocalNotificationScheduleIDs _$$_LocalNotificationScheduleIDsFromJson(
        Map<String, dynamic> json) =>
    _$_LocalNotificationScheduleIDs(
      ids: (json['ids'] as List<dynamic>)
          .map((e) =>
              LocalNotificationScheduleID.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_LocalNotificationScheduleIDsToJson(
        _$_LocalNotificationScheduleIDs instance) =>
    <String, dynamic>{
      'ids': instance.ids.map((e) => e.toJson()).toList(),
    };
