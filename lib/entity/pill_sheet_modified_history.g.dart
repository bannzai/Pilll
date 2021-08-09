// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetModifiedValue _$_$_PillSheetModifiedValueFromJson(
    Map<String, dynamic> json) {
  return _$_PillSheetModifiedValue(
    pillSheetDeletedAt: TimestampConverter.timestampToDateTime(
        json['pillSheetDeletedAt'] as Timestamp?),
    pillSheetCreatedAt: TimestampConverter.timestampToDateTime(
        json['pillSheetCreatedAt'] as Timestamp?),
    changedPillNumber: (json['changedPillNumber'] as List<dynamic>?)
        ?.map((e) => e as int)
        .toList(),
  );
}

Map<String, dynamic> _$_$_PillSheetModifiedValueToJson(
        _$_PillSheetModifiedValue instance) =>
    <String, dynamic>{
      'pillSheetDeletedAt':
          TimestampConverter.dateTimeToTimestamp(instance.pillSheetDeletedAt),
      'pillSheetCreatedAt':
          TimestampConverter.dateTimeToTimestamp(instance.pillSheetCreatedAt),
      'changedPillNumber': instance.changedPillNumber,
    };

_$_PillSheetModifiedHistory _$_$_PillSheetModifiedHistoryFromJson(
    Map<String, dynamic> json) {
  return _$_PillSheetModifiedHistory(
    actionType: json['actionType'] as String,
    userID: json['userID'] as String,
    value:
        PillSheetModifiedValue.fromJson(json['value'] as Map<String, dynamic>),
    createdAt: NonNullTimestampConverter.timestampToDateTime(
        json['createdAt'] as Timestamp),
  );
}

Map<String, dynamic> _$_$_PillSheetModifiedHistoryToJson(
        _$_PillSheetModifiedHistory instance) =>
    <String, dynamic>{
      'actionType': instance.actionType,
      'userID': instance.userID,
      'value': instance.value.toJson(),
      'createdAt':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt),
    };
