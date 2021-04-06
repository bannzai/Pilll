// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menstruation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Menstruation _$_$_MenstruationFromJson(Map<String, dynamic> json) {
  return _$_Menstruation(
    id: json['id'] as String?,
    beginDate: NonNullTimestampConverter.timestampToDateTime(
        json['beginDate'] as Timestamp),
    endDate: NonNullTimestampConverter.timestampToDateTime(
        json['endDate'] as Timestamp),
    isNotYetUserEdited: json['isNotYetUserEdited'] as bool,
    deletedAt:
        TimestampConverter.timestampToDateTime(json['deletedAt'] as Timestamp?),
    createdAt: NonNullTimestampConverter.timestampToDateTime(
        json['createdAt'] as Timestamp),
  );
}

Map<String, dynamic> _$_$_MenstruationToJson(_$_Menstruation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', toNull(instance.id));
  val['beginDate'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.beginDate);
  val['endDate'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.endDate);
  val['isNotYetUserEdited'] = instance.isNotYetUserEdited;
  val['deletedAt'] = TimestampConverter.dateTimeToTimestamp(instance.deletedAt);
  val['createdAt'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt);
  return val;
}
