// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PillSheetTypeInfo _$PillSheetTypeInfoFromJson(Map<String, dynamic> json) => _PillSheetTypeInfo(
  pillSheetTypeReferencePath: json['pillSheetTypeReferencePath'] as String,
  name: json['name'] as String,
  totalCount: (json['totalCount'] as num).toInt(),
  dosingPeriod: (json['dosingPeriod'] as num).toInt(),
);

Map<String, dynamic> _$PillSheetTypeInfoToJson(_PillSheetTypeInfo instance) => <String, dynamic>{
  'pillSheetTypeReferencePath': instance.pillSheetTypeReferencePath,
  'name': instance.name,
  'totalCount': instance.totalCount,
  'dosingPeriod': instance.dosingPeriod,
};

_RestDuration _$RestDurationFromJson(Map<String, dynamic> json) => _RestDuration(
  id: json['id'] as String?,
  beginDate: NonNullTimestampConverter.timestampToDateTime(json['beginDate'] as Timestamp),
  endDate: TimestampConverter.timestampToDateTime(json['endDate'] as Timestamp?),
  createdDate: NonNullTimestampConverter.timestampToDateTime(json['createdDate'] as Timestamp),
);

Map<String, dynamic> _$RestDurationToJson(_RestDuration instance) => <String, dynamic>{
  'id': instance.id,
  'beginDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.beginDate),
  'endDate': TimestampConverter.dateTimeToTimestamp(instance.endDate),
  'createdDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDate),
};

_PillSheet _$PillSheetFromJson(Map<String, dynamic> json) => _PillSheet(
  id: json['id'] as String?,
  typeInfo: PillSheetTypeInfo.fromJson(json['typeInfo'] as Map<String, dynamic>),
  beginingDate: NonNullTimestampConverter.timestampToDateTime(json['beginingDate'] as Timestamp),
  lastTakenDate: TimestampConverter.timestampToDateTime(json['lastTakenDate'] as Timestamp?),
  createdAt: TimestampConverter.timestampToDateTime(json['createdAt'] as Timestamp?),
  deletedAt: TimestampConverter.timestampToDateTime(json['deletedAt'] as Timestamp?),
  groupIndex: (json['groupIndex'] as num?)?.toInt() ?? 0,
  restDurations: (json['restDurations'] as List<dynamic>?)?.map((e) => RestDuration.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
);

Map<String, dynamic> _$PillSheetToJson(_PillSheet instance) => <String, dynamic>{
  'id': ?instance.id,
  'typeInfo': instance.typeInfo.toJson(),
  'beginingDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.beginingDate),
  'lastTakenDate': TimestampConverter.dateTimeToTimestamp(instance.lastTakenDate),
  'createdAt': TimestampConverter.dateTimeToTimestamp(instance.createdAt),
  'deletedAt': TimestampConverter.dateTimeToTimestamp(instance.deletedAt),
  'groupIndex': instance.groupIndex,
  'restDurations': instance.restDurations.map((e) => e.toJson()).toList(),
};
