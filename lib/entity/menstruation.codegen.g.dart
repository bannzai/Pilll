// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menstruation.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Menstruation _$MenstruationFromJson(Map<String, dynamic> json) => _Menstruation(
  id: json['id'] as String?,
  beginDate: NonNullTimestampConverter.timestampToDateTime(json['beginDate'] as Timestamp),
  endDate: NonNullTimestampConverter.timestampToDateTime(json['endDate'] as Timestamp),
  deletedAt: TimestampConverter.timestampToDateTime(json['deletedAt'] as Timestamp?),
  createdAt: NonNullTimestampConverter.timestampToDateTime(json['createdAt'] as Timestamp),
  healthKitSampleDataUUID: json['healthKitSampleDataUUID'] as String?,
);

Map<String, dynamic> _$MenstruationToJson(_Menstruation instance) => <String, dynamic>{
  'id': ?instance.id,
  'beginDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.beginDate),
  'endDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.endDate),
  'deletedAt': TimestampConverter.dateTimeToTimestamp(instance.deletedAt),
  'createdAt': NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt),
  'healthKitSampleDataUUID': instance.healthKitSampleDataUUID,
};
