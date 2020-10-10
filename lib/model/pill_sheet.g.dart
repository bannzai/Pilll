// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PillSheetTypeInfo _$PillSheetTypeInfoFromJson(Map<String, dynamic> json) {
  return PillSheetTypeInfo(
    pillSheetTypeReferencePath: json['pillSheetTypeReferencePath'] as String,
    totalCount: json['totalCount'] as int,
    dosingPeriod: json['dosingPeriod'] as int,
  );
}

Map<String, dynamic> _$PillSheetTypeInfoToJson(PillSheetTypeInfo instance) =>
    <String, dynamic>{
      'pillSheetTypeReferencePath': instance.pillSheetTypeReferencePath,
      'totalCount': instance.totalCount,
      'dosingPeriod': instance.dosingPeriod,
    };

PillSheetModel _$PillSheetModelFromJson(Map<String, dynamic> json) {
  return PillSheetModel(
    id: json['id'] as String,
    typeInfo:
        PillSheetTypeInfo.fromJson(json['typeInfo'] as Map<String, dynamic>),
    beginingDate: TimestampConverter.timestampToDateTime(
        json['beginingDate'] as Timestamp),
    lastTakenDate: TimestampConverter.timestampToDateTime(
        json['lastTakenDate'] as Timestamp),
  )
    ..createdAt =
        TimestampConverter.timestampToDateTime(json['createdAt'] as Timestamp)
    ..deletedAt =
        TimestampConverter.timestampToDateTime(json['deletedAt'] as Timestamp);
}

Map<String, dynamic> _$PillSheetModelToJson(PillSheetModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', toNull(instance.id));
  val['typeInfo'] = instance.typeInfo.toJson();
  val['beginingDate'] =
      TimestampConverter.dateTimeToTimestamp(instance.beginingDate);
  val['lastTakenDate'] =
      TimestampConverter.dateTimeToTimestamp(instance.lastTakenDate);
  val['createdAt'] = TimestampConverter.dateTimeToTimestamp(instance.createdAt);
  val['deletedAt'] = TimestampConverter.dateTimeToTimestamp(instance.deletedAt);
  return val;
}
