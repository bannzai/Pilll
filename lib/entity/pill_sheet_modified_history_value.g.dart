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
    beginTrialDate: json['beginTrialDate'] == null
        ? null
        : DateTime.parse(json['beginTrialDate'] as String),
    isTrial: json['isTrial'] as bool? ?? false,
    isPremium: json['isPremium'] as bool? ?? false,
    isLoading: json['isLoading'] as bool? ?? false,
    isFirstLoadEnded: json['isFirstLoadEnded'] as bool? ?? false,
    exception: json['exception'],
  );
}

Map<String, dynamic> _$_$_CreatedPillSheetValueToJson(
        _$_CreatedPillSheetValue instance) =>
    <String, dynamic>{
      'beginTrialDate': instance.beginTrialDate?.toIso8601String(),
      'isTrial': instance.isTrial,
      'isPremium': instance.isPremium,
      'isLoading': instance.isLoading,
      'isFirstLoadEnded': instance.isFirstLoadEnded,
      'exception': instance.exception,
    };
