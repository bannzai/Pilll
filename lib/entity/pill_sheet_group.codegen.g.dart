// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_group.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PillSheetGroup _$PillSheetGroupFromJson(Map<String, dynamic> json) => _PillSheetGroup(
  id: json['id'] as String?,
  pillSheetIDs: (json['pillSheetIDs'] as List<dynamic>).map((e) => e as String).toList(),
  pillSheets: (json['pillSheets'] as List<dynamic>).map((e) => PillSheet.fromJson(e as Map<String, dynamic>)).toList(),
  createdAt: NonNullTimestampConverter.timestampToDateTime(json['createdAt'] as Timestamp),
  deletedAt: TimestampConverter.timestampToDateTime(json['deletedAt'] as Timestamp?),
  displayNumberSetting: json['displayNumberSetting'] == null
      ? null
      : PillSheetGroupDisplayNumberSetting.fromJson(json['displayNumberSetting'] as Map<String, dynamic>),
  pillSheetAppearanceMode: $enumDecodeNullable(_$PillSheetAppearanceModeEnumMap, json['pillSheetAppearanceMode']) ?? PillSheetAppearanceMode.number,
);

Map<String, dynamic> _$PillSheetGroupToJson(_PillSheetGroup instance) => <String, dynamic>{
  'id': ?instance.id,
  'pillSheetIDs': instance.pillSheetIDs,
  'pillSheets': instance.pillSheets.map((e) => e.toJson()).toList(),
  'createdAt': NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt),
  'deletedAt': TimestampConverter.dateTimeToTimestamp(instance.deletedAt),
  'displayNumberSetting': instance.displayNumberSetting?.toJson(),
  'pillSheetAppearanceMode': _$PillSheetAppearanceModeEnumMap[instance.pillSheetAppearanceMode]!,
};

const _$PillSheetAppearanceModeEnumMap = {
  PillSheetAppearanceMode.number: 'number',
  PillSheetAppearanceMode.date: 'date',
  PillSheetAppearanceMode.sequential: 'sequential',
  PillSheetAppearanceMode.cyclicSequential: 'cyclicSequential',
};

_PillSheetGroupDisplayNumberSetting _$PillSheetGroupDisplayNumberSettingFromJson(Map<String, dynamic> json) => _PillSheetGroupDisplayNumberSetting(
  beginPillNumber: (json['beginPillNumber'] as num?)?.toInt(),
  endPillNumber: (json['endPillNumber'] as num?)?.toInt(),
);

Map<String, dynamic> _$PillSheetGroupDisplayNumberSettingToJson(_PillSheetGroupDisplayNumberSetting instance) => <String, dynamic>{
  'beginPillNumber': instance.beginPillNumber,
  'endPillNumber': instance.endPillNumber,
};
