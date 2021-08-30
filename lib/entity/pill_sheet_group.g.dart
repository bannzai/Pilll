// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetGroup _$_$_PillSheetGroupFromJson(Map<String, dynamic> json) {
  return _$_PillSheetGroup(
    pillSheetIDs: (json['pillSheetIDs'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    pillSheets: (json['pillSheets'] as List<dynamic>)
        .map((e) => PillSheet.fromJson(e as Map<String, dynamic>))
        .toList(),
    createdAt:
        TimestampConverter.timestampToDateTime(json['createdAt'] as Timestamp?),
    deletedAt:
        TimestampConverter.timestampToDateTime(json['deletedAt'] as Timestamp?),
  );
}

Map<String, dynamic> _$_$_PillSheetGroupToJson(_$_PillSheetGroup instance) =>
    <String, dynamic>{
      'pillSheetIDs': instance.pillSheetIDs,
      'pillSheets': instance.pillSheets.map((e) => e.toJson()).toList(),
      'createdAt': TimestampConverter.dateTimeToTimestamp(instance.createdAt),
      'deletedAt': TimestampConverter.dateTimeToTimestamp(instance.deletedAt),
    };
