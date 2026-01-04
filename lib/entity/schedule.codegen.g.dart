// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleImpl _$$ScheduleImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleImpl(
      id: json['id'] as String?,
      title: json['title'] as String,
      date: NonNullTimestampConverter.timestampToDateTime(
          json['date'] as Timestamp),
      localNotification: json['localNotification'] == null
          ? null
          : LocalNotification.fromJson(
              json['localNotification'] as Map<String, dynamic>),
      createdDateTime: NonNullTimestampConverter.timestampToDateTime(
          json['createdDateTime'] as Timestamp),
    );

Map<String, dynamic> _$$ScheduleImplToJson(_$ScheduleImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['title'] = instance.title;
  val['date'] = NonNullTimestampConverter.dateTimeToTimestamp(instance.date);
  val['localNotification'] = instance.localNotification?.toJson();
  val['createdDateTime'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDateTime);
  return val;
}

_$LocalNotificationImpl _$$LocalNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$LocalNotificationImpl(
      localNotificationID: (json['localNotificationID'] as num).toInt(),
      remindDateTime: NonNullTimestampConverter.timestampToDateTime(
          json['remindDateTime'] as Timestamp),
    );

Map<String, dynamic> _$$LocalNotificationImplToJson(
        _$LocalNotificationImpl instance) =>
    <String, dynamic>{
      'localNotificationID': instance.localNotificationID,
      'remindDateTime': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.remindDateTime),
    };
