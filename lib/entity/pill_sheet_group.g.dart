// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetGroup _$_$_PillSheetGroupFromJson(Map<String, dynamic> json) {
  return _$_PillSheetGroup(
    id: json['id'] as String?,
    pillSheetIDs: (json['pillSheetIDs'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    pillSheets: (json['pillSheets'] as List<dynamic>)
        .map((e) => PillSheet.fromJson(e as Map<String, dynamic>))
        .toList(),
    createdAt: NonNullTimestampConverter.timestampToDateTime(
        json['createdAt'] as Timestamp),
    deletedAt:
        TimestampConverter.timestampToDateTime(json['deletedAt'] as Timestamp?),
  );
}

Map<String, dynamic> _$_$_PillSheetGroupToJson(_$_PillSheetGroup instance) {
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
  return val;
}
