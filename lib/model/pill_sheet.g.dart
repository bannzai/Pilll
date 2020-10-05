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
    typeInfo:
        PillSheetTypeInfo.fromJson(json['typeInfo'] as Map<String, dynamic>),
    beginingDate: DateTime.parse(json['beginingDate'] as String),
    lastTakenDate: TimestampConverter.timestampToDateTime(
        json['lastTakenDate'] as Timestamp),
  )
    ..createdAt =
        TimestampConverter.timestampToDateTime(json['createdAt'] as Timestamp)
    ..deletedAt =
        TimestampConverter.timestampToDateTime(json['deletedAt'] as Timestamp);
}

Map<String, dynamic> _$PillSheetModelToJson(PillSheetModel instance) =>
    <String, dynamic>{
      'typeInfo': instance.typeInfo,
      'beginingDate': instance.beginingDate.toIso8601String(),
      'lastTakenDate':
          TimestampConverter.dateTimeToTimestamp(instance.lastTakenDate),
      'createdAt': TimestampConverter.dateTimeToTimestamp(instance.createdAt),
      'deletedAt': TimestampConverter.dateTimeToTimestamp(instance.deletedAt),
    };
