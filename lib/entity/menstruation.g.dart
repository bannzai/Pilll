// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menstruation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Menstruation _$_$_MenstruationFromJson(Map<String, dynamic> json) {
  return _$_Menstruation(
    beginDate: NonNullTimestampConverter.timestampToDateTime(
        json['beginDate'] as Timestamp),
    endDate: NonNullTimestampConverter.timestampToDateTime(
        json['endDate'] as Timestamp),
    isPreview: json['isPreview'] as bool,
    deletedAt:
        TimestampConverter.timestampToDateTime(json['deletedAt'] as Timestamp?),
    createdAt: NonNullTimestampConverter.timestampToDateTime(
        json['createdAt'] as Timestamp),
  );
}

Map<String, dynamic> _$_$_MenstruationToJson(_$_Menstruation instance) =>
    <String, dynamic>{
      'beginDate':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.beginDate),
      'endDate':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.endDate),
      'isPreview': instance.isPreview,
      'deletedAt': TimestampConverter.dateTimeToTimestamp(instance.deletedAt),
      'createdAt':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt),
    };
