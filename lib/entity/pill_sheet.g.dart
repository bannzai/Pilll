// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetTypeInfo _$_$_PillSheetTypeInfoFromJson(Map<String, dynamic> json) {
  return _$_PillSheetTypeInfo(
    pillSheetTypeReferencePath: json['pillSheetTypeReferencePath'] as String,
    name: json['name'] as String,
    totalCount: json['totalCount'] as int,
    dosingPeriod: json['dosingPeriod'] as int,
  );
}

Map<String, dynamic> _$_$_PillSheetTypeInfoToJson(
        _$_PillSheetTypeInfo instance) =>
    <String, dynamic>{
      'pillSheetTypeReferencePath': instance.pillSheetTypeReferencePath,
      'name': instance.name,
      'totalCount': instance.totalCount,
      'dosingPeriod': instance.dosingPeriod,
    };

_$_PillSheetModel _$_$_PillSheetModelFromJson(Map<String, dynamic> json) {
  return _$_PillSheetModel(
    id: json['id'] as String?,
    typeInfo:
        PillSheetTypeInfo.fromJson(json['typeInfo'] as Map<String, dynamic>),
    beginingDate: NonNullTimestampConverter.timestampToDateTime(
        json['beginingDate'] as Timestamp),
    lastTakenDate: TimestampConverter.timestampToDateTime(
        json['lastTakenDate'] as Timestamp?),
    createdAt:
        TimestampConverter.timestampToDateTime(json['createdAt'] as Timestamp?),
    deletedAt:
        TimestampConverter.timestampToDateTime(json['deletedAt'] as Timestamp?),
  );
}

Map<String, dynamic> _$_$_PillSheetModelToJson(_$_PillSheetModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', toNull(instance.id));
  val['typeInfo'] = instance.typeInfo.toJson();
  val['beginingDate'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.beginingDate);
  val['lastTakenDate'] =
      TimestampConverter.dateTimeToTimestamp(instance.lastTakenDate);
  val['createdAt'] = TimestampConverter.dateTimeToTimestamp(instance.createdAt);
  val['deletedAt'] = TimestampConverter.dateTimeToTimestamp(instance.deletedAt);
  return val;
}
