// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PillSheetTypeInfoImpl _$$PillSheetTypeInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$PillSheetTypeInfoImpl(
      pillSheetTypeReferencePath: json['pillSheetTypeReferencePath'] as String,
      name: json['name'] as String,
      totalCount: (json['totalCount'] as num).toInt(),
      dosingPeriod: (json['dosingPeriod'] as num).toInt(),
    );

Map<String, dynamic> _$$PillSheetTypeInfoImplToJson(
        _$PillSheetTypeInfoImpl instance) =>
    <String, dynamic>{
      'pillSheetTypeReferencePath': instance.pillSheetTypeReferencePath,
      'name': instance.name,
      'totalCount': instance.totalCount,
      'dosingPeriod': instance.dosingPeriod,
    };

_$RestDurationImpl _$$RestDurationImplFromJson(Map<String, dynamic> json) =>
    _$RestDurationImpl(
      id: json['id'] as String?,
      beginDate: NonNullTimestampConverter.timestampToDateTime(
          json['beginDate'] as Timestamp),
      endDate:
          TimestampConverter.timestampToDateTime(json['endDate'] as Timestamp?),
      createdDate: NonNullTimestampConverter.timestampToDateTime(
          json['createdDate'] as Timestamp),
    );

Map<String, dynamic> _$$RestDurationImplToJson(_$RestDurationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'beginDate':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.beginDate),
      'endDate': TimestampConverter.dateTimeToTimestamp(instance.endDate),
      'createdDate':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDate),
    };

_$PillSheetImpl _$$PillSheetImplFromJson(Map<String, dynamic> json) =>
    _$PillSheetImpl(
      id: json['id'] as String?,
      typeInfo:
          PillSheetTypeInfo.fromJson(json['typeInfo'] as Map<String, dynamic>),
      beginingDate: NonNullTimestampConverter.timestampToDateTime(
          json['beginingDate'] as Timestamp),
      lastTakenDate: TimestampConverter.timestampToDateTime(
          json['lastTakenDate'] as Timestamp?),
      createdAt: TimestampConverter.timestampToDateTime(
          json['createdAt'] as Timestamp?),
      deletedAt: TimestampConverter.timestampToDateTime(
          json['deletedAt'] as Timestamp?),
      groupIndex: (json['groupIndex'] as num?)?.toInt() ?? 0,
      restDurations: (json['restDurations'] as List<dynamic>?)
              ?.map((e) => RestDuration.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PillSheetImplToJson(_$PillSheetImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['typeInfo'] = instance.typeInfo.toJson();
  val['beginingDate'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.beginingDate);
  val['lastTakenDate'] =
      TimestampConverter.dateTimeToTimestamp(instance.lastTakenDate);
  val['createdAt'] = TimestampConverter.dateTimeToTimestamp(instance.createdAt);
  val['deletedAt'] = TimestampConverter.dateTimeToTimestamp(instance.deletedAt);
  val['groupIndex'] = instance.groupIndex;
  val['restDurations'] = instance.restDurations.map((e) => e.toJson()).toList();
  return val;
}
