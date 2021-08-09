// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetModifiedHistory _$_$_PillSheetModifiedHistoryFromJson(
    Map<String, dynamic> json) {
  return _$_PillSheetModifiedHistory(
    actionType: json['actionType'] as String,
    userID: json['userID'] as String,
    value: PillSheetModifiedHistoryValue.fromJson(
        json['value'] as Map<String, dynamic>),
    after: PillSheet.fromJson(json['after'] as Map<String, dynamic>),
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
      'after': instance.after.toJson(),
      'createdAt':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt),
    };
