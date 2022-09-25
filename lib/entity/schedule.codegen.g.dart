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
      remindDateTime: TimestampConverter.timestampToDateTime(
          json['remindDateTime'] as Timestamp?),
      createdDateTime: NonNullTimestampConverter.timestampToDateTime(
          json['createdDateTime'] as Timestamp),
    );

Map<String, dynamic> _$$_ScheduleToJson(_$_Schedule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': NonNullTimestampConverter.dateTimeToTimestamp(instance.date),
      'remindDateTime':
          TimestampConverter.dateTimeToTimestamp(instance.remindDateTime),
      'createdDateTime': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.createdDateTime),
    };
