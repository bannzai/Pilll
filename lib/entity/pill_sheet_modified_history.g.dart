// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetModifiedValue _$_$_PillSheetModifiedValueFromJson(
    Map<String, dynamic> json) {
  return _$_PillSheetModifiedValue(
    pillSheetDeletedAt: json['pillSheetDeletedAt'] == null
        ? null
        : DateTime.parse(json['pillSheetDeletedAt'] as String),
    pillSheetCreatedAt: json['pillSheetCreatedAt'] == null
        ? null
        : DateTime.parse(json['pillSheetCreatedAt'] as String),
    changedPillNumber: (json['changedPillNumber'] as List<dynamic>?)
        ?.map((e) => e as int)
        .toList(),
  );
}

Map<String, dynamic> _$_$_PillSheetModifiedValueToJson(
        _$_PillSheetModifiedValue instance) =>
    <String, dynamic>{
      'pillSheetDeletedAt': instance.pillSheetDeletedAt?.toIso8601String(),
      'pillSheetCreatedAt': instance.pillSheetCreatedAt?.toIso8601String(),
      'changedPillNumber': instance.changedPillNumber,
    };

_$_PillSheetModifiedHistory _$_$_PillSheetModifiedHistoryFromJson(
    Map<String, dynamic> json) {
  return _$_PillSheetModifiedHistory(
    actionType: json['actionType'] as String,
    userID: json['userID'] as String,
    value:
        PillSheetModifiedValue.fromJson(json['value'] as Map<String, dynamic>),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}

Map<String, dynamic> _$_$_PillSheetModifiedHistoryToJson(
        _$_PillSheetModifiedHistory instance) =>
    <String, dynamic>{
      'actionType': instance.actionType,
      'userID': instance.userID,
      'value': instance.value.toJson(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
