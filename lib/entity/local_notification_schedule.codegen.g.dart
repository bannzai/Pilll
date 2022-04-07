// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_notification_schedule.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LocalNotificationSchedule _$$_LocalNotificationScheduleFromJson(
        Map<String, dynamic> json) =>
    _$_LocalNotificationSchedule(
      kind: $enumDecode(_$LocalNotificationScheduleKindEnumMap, json['kind']),
      localNotification: json['localNotification'] as int,
      scheduleDateTime: DateTime.parse(json['scheduleDateTime'] as String),
    );

Map<String, dynamic> _$$_LocalNotificationScheduleToJson(
        _$_LocalNotificationSchedule instance) =>
    <String, dynamic>{
      'kind': _$LocalNotificationScheduleKindEnumMap[instance.kind],
      'localNotification': instance.localNotification,
      'scheduleDateTime': instance.scheduleDateTime.toIso8601String(),
    };

const _$LocalNotificationScheduleKindEnumMap = {
  LocalNotificationScheduleKind.reminderNotification: 'reminderNotification',
};
