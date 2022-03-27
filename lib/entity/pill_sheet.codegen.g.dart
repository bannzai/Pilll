// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetTypeInfo _$$_PillSheetTypeInfoFromJson(Map<String, dynamic> json) =>
    _$_PillSheetTypeInfo(
      pillSheetTypeReferencePath: json['pillSheetTypeReferencePath'] as String,
      name: json['name'] as String,
      totalCount: json['totalCount'] as int,
      dosingPeriod: json['dosingPeriod'] as int,
    );

Map<String, dynamic> _$$_PillSheetTypeInfoToJson(
        _$_PillSheetTypeInfo instance) =>
    <String, dynamic>{
      'pillSheetTypeReferencePath': instance.pillSheetTypeReferencePath,
      'name': instance.name,
      'totalCount': instance.totalCount,
      'dosingPeriod': instance.dosingPeriod,
    };

_$_RestDuration _$$_RestDurationFromJson(Map<String, dynamic> json) =>
    _$_RestDuration(
      beginDate: NonNullTimestampConverter.timestampToDateTime(
          json['beginDate'] as Timestamp),
      endDate:
          TimestampConverter.timestampToDateTime(json['endDate'] as Timestamp?),
      createdDate: NonNullTimestampConverter.timestampToDateTime(
          json['createdDate'] as Timestamp),
    );

Map<String, dynamic> _$$_RestDurationToJson(_$_RestDuration instance) =>
    <String, dynamic>{
      'beginDate':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.beginDate),
      'endDate': TimestampConverter.dateTimeToTimestamp(instance.endDate),
      'createdDate':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDate),
    };

_$_PillSheet _$$_PillSheetFromJson(Map<String, dynamic> json) => _$_PillSheet(
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
      groupIndex: json['groupIndex'] as int? ?? 0,
      restDurations: (json['restDurations'] as List<dynamic>?)
              ?.map((e) => RestDuration.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_PillSheetToJson(_$_PillSheet instance) {
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
