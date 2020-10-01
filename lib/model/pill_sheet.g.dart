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
    beginingDate: TimestampConverter.timestampToDateTime(
        json['beginingDate'] as Timestamp),
    lastTakenDate: TimestampConverter.timestampToDateTime(
        json['lastTakenDate'] as Timestamp),
  );
}

Map<String, dynamic> _$PillSheetModelToJson(PillSheetModel instance) =>
    <String, dynamic>{
      'typeInfo': instance.typeInfo,
      'beginingDate':
          TimestampConverter.dateTimeToTimestamp(instance.beginingDate),
      'lastTakenDate':
          TimestampConverter.dateTimeToTimestamp(instance.lastTakenDate),
    };
