// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_group.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PillSheetGroupImpl _$$PillSheetGroupImplFromJson(Map<String, dynamic> json) =>
    _$PillSheetGroupImpl(
      id: json['id'] as String?,
      pillSheetIDs: (json['pillSheetIDs'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      pillSheets: (json['pillSheets'] as List<dynamic>)
          .map((e) => PillSheet.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: NonNullTimestampConverter.timestampToDateTime(
          json['createdAt'] as Timestamp),
      deletedAt: TimestampConverter.timestampToDateTime(
          json['deletedAt'] as Timestamp?),
      displayNumberSetting: json['displayNumberSetting'] == null
          ? null
          : PillSheetGroupDisplayNumberSetting.fromJson(
              json['displayNumberSetting'] as Map<String, dynamic>),
      pillSheetAppearanceMode: $enumDecodeNullable(
              _$PillSheetAppearanceModeEnumMap,
              json['pillSheetAppearanceMode']) ??
          PillSheetAppearanceMode.number,
    );

Map<String, dynamic> _$$PillSheetGroupImplToJson(
    _$PillSheetGroupImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['pillSheetIDs'] = instance.pillSheetIDs;
  val['pillSheets'] = instance.pillSheets.map((e) => e.toJson()).toList();
  val['createdAt'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt);
  val['deletedAt'] = TimestampConverter.dateTimeToTimestamp(instance.deletedAt);
  val['displayNumberSetting'] = instance.displayNumberSetting?.toJson();
  val['pillSheetAppearanceMode'] =
      _$PillSheetAppearanceModeEnumMap[instance.pillSheetAppearanceMode]!;
  return val;
}

const _$PillSheetAppearanceModeEnumMap = {
  PillSheetAppearanceMode.number: 'number',
  PillSheetAppearanceMode.date: 'date',
  PillSheetAppearanceMode.sequential: 'sequential',
  PillSheetAppearanceMode.cyclicSequential: 'cyclicSequential',
};

_$PillSheetGroupDisplayNumberSettingImpl
    _$$PillSheetGroupDisplayNumberSettingImplFromJson(
            Map<String, dynamic> json) =>
        _$PillSheetGroupDisplayNumberSettingImpl(
          beginPillNumber: (json['beginPillNumber'] as num?)?.toInt(),
          endPillNumber: (json['endPillNumber'] as num?)?.toInt(),
        );

Map<String, dynamic> _$$PillSheetGroupDisplayNumberSettingImplToJson(
        _$PillSheetGroupDisplayNumberSettingImpl instance) =>
    <String, dynamic>{
      'beginPillNumber': instance.beginPillNumber,
      'endPillNumber': instance.endPillNumber,
    };
