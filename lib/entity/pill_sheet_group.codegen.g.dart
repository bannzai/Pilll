// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_group.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetGroup _$$_PillSheetGroupFromJson(Map<String, dynamic> json) =>
    _$_PillSheetGroup(
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
    );

Map<String, dynamic> _$$_PillSheetGroupToJson(_$_PillSheetGroup instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', toNull(instance.id));
  val['pillSheetIDs'] = instance.pillSheetIDs;
  val['pillSheets'] = instance.pillSheets.map((e) => e.toJson()).toList();
  val['createdAt'] =
      NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt);
  val['deletedAt'] = TimestampConverter.dateTimeToTimestamp(instance.deletedAt);
  val['displayNumberSetting'] = instance.displayNumberSetting?.toJson();
  return val;
}

_$_PillSheetGroupDisplayNumberSetting
    _$$_PillSheetGroupDisplayNumberSettingFromJson(Map<String, dynamic> json) =>
        _$_PillSheetGroupDisplayNumberSetting(
          beginPillNumber: json['beginPillNumber'] as int?,
          endPillNumber: json['endPillNumber'] as int?,
        );

Map<String, dynamic> _$$_PillSheetGroupDisplayNumberSettingToJson(
        _$_PillSheetGroupDisplayNumberSetting instance) =>
    <String, dynamic>{
      'beginPillNumber': instance.beginPillNumber,
      'endPillNumber': instance.endPillNumber,
    };
