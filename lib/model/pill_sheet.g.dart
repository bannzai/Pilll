// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetTypeInfo _$_$_PillSheetTypeInfoFromJson(Map<String, dynamic> json) {
  return _$_PillSheetTypeInfo(
    pillSheetTypeReferencePath: json['pillSheetTypeReferencePath'] as String,
    totalCount: json['totalCount'] as int,
    dosingPeriod: json['dosingPeriod'] as int,
  );
}

Map<String, dynamic> _$_$_PillSheetTypeInfoToJson(
        _$_PillSheetTypeInfo instance) =>
    <String, dynamic>{
      'pillSheetTypeReferencePath': instance.pillSheetTypeReferencePath,
      'totalCount': instance.totalCount,
      'dosingPeriod': instance.dosingPeriod,
    };

_$_PillSheetModel _$_$_PillSheetModelFromJson(Map<String, dynamic> json) {
  return _$_PillSheetModel(
    typeInfo: json['typeInfo'] == null
        ? null
        : PillSheetTypeInfo.fromJson(json['typeInfo'] as Map<String, dynamic>),
    beginingDate: json['beginingDate'] == null
        ? null
        : DateTime.parse(json['beginingDate'] as String),
    lastTakenDate: json['lastTakenDate'] == null
        ? null
        : DateTime.parse(json['lastTakenDate'] as String),
  );
}

Map<String, dynamic> _$_$_PillSheetModelToJson(_$_PillSheetModel instance) =>
    <String, dynamic>{
      'typeInfo': instance.typeInfo,
      'beginingDate': instance.beginingDate?.toIso8601String(),
      'lastTakenDate': instance.lastTakenDate?.toIso8601String(),
    };
