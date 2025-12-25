// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Schedule _$ScheduleFromJson(Map<String, dynamic> json) => _Schedule(
  id: json['id'] as String?,
  title: json['title'] as String,
  date: NonNullTimestampConverter.timestampToDateTime(json['date'] as Timestamp),
  localNotification: json['localNotification'] == null ? null : LocalNotification.fromJson(json['localNotification'] as Map<String, dynamic>),
  createdDateTime: NonNullTimestampConverter.timestampToDateTime(json['createdDateTime'] as Timestamp),
);

Map<String, dynamic> _$ScheduleToJson(_Schedule instance) => <String, dynamic>{
  'id': ?instance.id,
  'title': instance.title,
  'date': NonNullTimestampConverter.dateTimeToTimestamp(instance.date),
  'localNotification': instance.localNotification?.toJson(),
  'createdDateTime': NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDateTime),
};

_LocalNotification _$LocalNotificationFromJson(Map<String, dynamic> json) => _LocalNotification(
  localNotificationID: (json['localNotificationID'] as num).toInt(),
  remindDateTime: NonNullTimestampConverter.timestampToDateTime(json['remindDateTime'] as Timestamp),
);

Map<String, dynamic> _$LocalNotificationToJson(_LocalNotification instance) => <String, dynamic>{
  'localNotificationID': instance.localNotificationID,
  'remindDateTime': NonNullTimestampConverter.dateTimeToTimestamp(instance.remindDateTime),
};
