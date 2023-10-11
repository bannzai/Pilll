// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menstruation.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Menstruation _$$_MenstruationFromJson(Map<String, dynamic> json) =>
    _$_Menstruation(
      id: json['id'] as String?,
      beginDate: NonNullTimestampConverter.timestampToDateTime(
          json['beginDate'] as Timestamp),
      endDate: NonNullTimestampConverter.timestampToDateTime(
          json['endDate'] as Timestamp),
      deletedAt: TimestampConverter.timestampToDateTime(
          json['deletedAt'] as Timestamp?),
      createdAt: NonNullTimestampConverter.timestampToDateTime(
          json['createdAt'] as Timestamp),
      healthKitSampleDataUUID: json['healthKitSampleDataUUID'] as String?,
    );

Map<String, dynamic> _$$_MenstruationToJson(_$_Menstruation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['beginDate'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.beginDate);
  val['endDate'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.endDate);
  val['deletedAt'] = TimestampConverter.dateTimeToTimestamp(instance.deletedAt);
  val['createdAt'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt);
  val['healthKitSampleDataUUID'] = instance.healthKitSampleDataUUID;
  return val;
}
