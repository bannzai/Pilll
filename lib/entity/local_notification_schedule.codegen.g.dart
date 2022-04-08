// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_notification_schedule.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LocalNotificationSchedule _$$_LocalNotificationScheduleFromJson(
        Map<String, dynamic> json) =>
    _$_LocalNotificationSchedule(
      kind: $enumDecode(_$LocalNotificationScheduleKindEnumMap, json['kind']),
      scheduleDateTime: DateTime.parse(json['scheduleDateTime'] as String),
      localNotificationID: json['localNotificationID'] as int,
      createdDate: NonNullTimestampConverter.timestampToDateTime(
          json['createdDate'] as Timestamp),
    );

Map<String, dynamic> _$$_LocalNotificationScheduleToJson(
        _$_LocalNotificationSchedule instance) =>
    <String, dynamic>{
      'kind': _$LocalNotificationScheduleKindEnumMap[instance.kind],
      'scheduleDateTime': instance.scheduleDateTime.toIso8601String(),
      'localNotificationID': instance.localNotificationID,
      'createdDate':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDate),
    };

const _$LocalNotificationScheduleKindEnumMap = {
  LocalNotificationScheduleKind.reminderNotification: 'reminderNotification',
};

_$_LocalNotificationScheduleDocument
    _$$_LocalNotificationScheduleDocumentFromJson(Map<String, dynamic> json) =>
        _$_LocalNotificationScheduleDocument(
          kind:
              $enumDecode(_$LocalNotificationScheduleKindEnumMap, json['kind']),
          schedules: (json['schedules'] as List<dynamic>)
              .map((e) =>
                  LocalNotificationSchedule.fromJson(e as Map<String, dynamic>))
              .toList(),
          createdDate: NonNullTimestampConverter.timestampToDateTime(
              json['createdDate'] as Timestamp),
        );

Map<String, dynamic> _$$_LocalNotificationScheduleDocumentToJson(
        _$_LocalNotificationScheduleDocument instance) =>
    <String, dynamic>{
      'kind': _$LocalNotificationScheduleKindEnumMap[instance.kind],
      'schedules': instance.schedules.map((e) => e.toJson()).toList(),
      'createdDate':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDate),
    };
