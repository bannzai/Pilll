// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_notification_schedule.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LocalNotificationSchedule _$$_LocalNotificationScheduleFromJson(
        Map<String, dynamic> json) =>
    _$_LocalNotificationSchedule(
      kind: $enumDecode(_$LocalNotificationScheduleKindEnumMap, json['kind']),
      title: json['title'] as String,
      message: json['message'] as String,
      localNotificationIDWithoutOffset:
          json['localNotificationIDWithoutOffset'] as int,
      localNotificationIDOffset: json['localNotificationIDOffset'] as int,
      scheduleDateTime: NonNullTimestampConverter.timestampToDateTime(
          json['scheduleDateTime'] as Timestamp),
      createdDate: NonNullTimestampConverter.timestampToDateTime(
          json['createdDate'] as Timestamp),
    );

Map<String, dynamic> _$$_LocalNotificationScheduleToJson(
        _$_LocalNotificationSchedule instance) =>
    <String, dynamic>{
      'kind': _$LocalNotificationScheduleKindEnumMap[instance.kind],
      'title': instance.title,
      'message': instance.message,
      'localNotificationIDWithoutOffset':
          instance.localNotificationIDWithoutOffset,
      'localNotificationIDOffset': instance.localNotificationIDOffset,
      'scheduleDateTime': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.scheduleDateTime),
      'createdDate':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDate),
    };

const _$LocalNotificationScheduleKindEnumMap = {
  LocalNotificationScheduleKind.reminderNotification: 'reminderNotification',
};

_$_LocalNotificationScheduleCollection
    _$$_LocalNotificationScheduleCollectionFromJson(
            Map<String, dynamic> json) =>
        _$_LocalNotificationScheduleCollection(
          kind:
              $enumDecode(_$LocalNotificationScheduleKindEnumMap, json['kind']),
          schedules: (json['schedules'] as List<dynamic>)
              .map((e) =>
                  LocalNotificationSchedule.fromJson(e as Map<String, dynamic>))
              .toList(),
          createdDate: NonNullTimestampConverter.timestampToDateTime(
              json['createdDate'] as Timestamp),
        );

Map<String, dynamic> _$$_LocalNotificationScheduleCollectionToJson(
        _$_LocalNotificationScheduleCollection instance) =>
    <String, dynamic>{
      'kind': _$LocalNotificationScheduleKindEnumMap[instance.kind],
      'schedules': instance.schedules.map((e) => e.toJson()).toList(),
      'createdDate':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDate),
    };
