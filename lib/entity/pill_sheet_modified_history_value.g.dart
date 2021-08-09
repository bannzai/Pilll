// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history_value.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetModifiedHistoryValue _$_$_PillSheetModifiedHistoryValueFromJson(
    Map<String, dynamic> json) {
  return _$_PillSheetModifiedHistoryValue(
    beginTrialDate: json['beginTrialDate'] == null
        ? null
        : DateTime.parse(json['beginTrialDate'] as String),
    createdPillSheet: CreatedPillSheetValue.fromJson(
        json['createdPillSheet'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_PillSheetModifiedHistoryValueToJson(
        _$_PillSheetModifiedHistoryValue instance) =>
    <String, dynamic>{
      'beginTrialDate': instance.beginTrialDate?.toIso8601String(),
      'createdPillSheet': instance.createdPillSheet.toJson(),
    };

_$_CreatedPillSheetValue _$_$_CreatedPillSheetValueFromJson(
    Map<String, dynamic> json) {
  return _$_CreatedPillSheetValue(
    pillSheetCreatedAt: NonNullTimestampConverter.timestampToDateTime(
        json['pillSheetCreatedAt'] as Timestamp),
  );
}

Map<String, dynamic> _$_$_CreatedPillSheetValueToJson(
        _$_CreatedPillSheetValue instance) =>
    <String, dynamic>{
      'pillSheetCreatedAt': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.pillSheetCreatedAt),
    };
