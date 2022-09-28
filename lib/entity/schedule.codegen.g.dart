// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Schedule _$$_ScheduleFromJson(Map<String, dynamic> json) => _$_Schedule(
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

Map<String, dynamic> _$$_ScheduleToJson(_$_Schedule instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', toNull(instance.id));
  val['title'] = instance.title;
  val['date'] = NonNullTimestampConverter.dateTimeToTimestamp(instance.date);
  val['localNotification'] = instance.localNotification?.toJson();
  val['createdDateTime'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDateTime);
  return val;
}

_$_LocalNotification _$$_LocalNotificationFromJson(Map<String, dynamic> json) =>
    _$_LocalNotification(
      localNotificationID: json['localNotificationID'] as int,
      remindDateTime: NonNullTimestampConverter.timestampToDateTime(
          json['remindDateTime'] as Timestamp),
    );

Map<String, dynamic> _$$_LocalNotificationToJson(
        _$_LocalNotification instance) =>
    <String, dynamic>{
      'localNotificationID': instance.localNotificationID,
      'remindDateTime': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.remindDateTime),
    };
