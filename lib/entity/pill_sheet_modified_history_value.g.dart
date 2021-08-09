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
    createdPillSheet: json['createdPillSheet'] == null
        ? null
        : CreatedPillSheetValue.fromJson(
            json['createdPillSheet'] as Map<String, dynamic>),
    automaticallyRecordedLastTakenDateValue:
        json['automaticallyRecordedLastTakenDateValue'] == null
            ? null
            : AutomaticallyRecordedLastTakenDateValue.fromJson(
                json['automaticallyRecordedLastTakenDateValue']
                    as Map<String, dynamic>),
    deletedPillSheetValue: json['deletedPillSheetValue'] == null
        ? null
        : DeletedPillSheetValue.fromJson(
            json['deletedPillSheetValue'] as Map<String, dynamic>),
    takenPillValue: json['takenPillValue'] == null
        ? null
        : TakenPillValue.fromJson(
            json['takenPillValue'] as Map<String, dynamic>),
    revertTakenPill: json['revertTakenPill'] == null
        ? null
        : RevertTakenPillValue.fromJson(
            json['revertTakenPill'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_PillSheetModifiedHistoryValueToJson(
        _$_PillSheetModifiedHistoryValue instance) =>
    <String, dynamic>{
      'beginTrialDate': instance.beginTrialDate?.toIso8601String(),
      'createdPillSheet': instance.createdPillSheet?.toJson(),
      'automaticallyRecordedLastTakenDateValue':
          instance.automaticallyRecordedLastTakenDateValue?.toJson(),
      'deletedPillSheetValue': instance.deletedPillSheetValue?.toJson(),
      'takenPillValue': instance.takenPillValue?.toJson(),
      'revertTakenPill': instance.revertTakenPill?.toJson(),
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

_$_AutomaticallyRecordedLastTakenDateValue
    _$_$_AutomaticallyRecordedLastTakenDateValueFromJson(
        Map<String, dynamic> json) {
  return _$_AutomaticallyRecordedLastTakenDateValue(
    beforeLastTakenPillNumber: json['beforeLastTakenPillNumber'] as int,
    afterLastTakenPillNumber: json['afterLastTakenPillNumber'] as int,
  );
}

Map<String, dynamic> _$_$_AutomaticallyRecordedLastTakenDateValueToJson(
        _$_AutomaticallyRecordedLastTakenDateValue instance) =>
    <String, dynamic>{
      'beforeLastTakenPillNumber': instance.beforeLastTakenPillNumber,
      'afterLastTakenPillNumber': instance.afterLastTakenPillNumber,
    };

_$_DeletedPillSheetValue _$_$_DeletedPillSheetValueFromJson(
    Map<String, dynamic> json) {
  return _$_DeletedPillSheetValue(
    pillSheetDeletedAt: NonNullTimestampConverter.timestampToDateTime(
        json['pillSheetDeletedAt'] as Timestamp),
  );
}

Map<String, dynamic> _$_$_DeletedPillSheetValueToJson(
        _$_DeletedPillSheetValue instance) =>
    <String, dynamic>{
      'pillSheetDeletedAt': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.pillSheetDeletedAt),
    };

_$_TakenPillValue _$_$_TakenPillValueFromJson(Map<String, dynamic> json) {
  return _$_TakenPillValue(
    beforeLastTakenDate: TimestampConverter.timestampToDateTime(
        json['beforeLastTakenDate'] as Timestamp?),
    afterLastTakenDate: NonNullTimestampConverter.timestampToDateTime(
        json['afterLastTakenDate'] as Timestamp),
    beforeLastTakenPillNumber: json['beforeLastTakenPillNumber'] as int?,
    afterLastTakenPillNumber: json['afterLastTakenPillNumber'] as int,
  );
}

Map<String, dynamic> _$_$_TakenPillValueToJson(_$_TakenPillValue instance) =>
    <String, dynamic>{
      'beforeLastTakenDate':
          TimestampConverter.dateTimeToTimestamp(instance.beforeLastTakenDate),
      'afterLastTakenDate': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.afterLastTakenDate),
      'beforeLastTakenPillNumber': instance.beforeLastTakenPillNumber,
      'afterLastTakenPillNumber': instance.afterLastTakenPillNumber,
    };

_$_RevertTakenPillValue _$_$_RevertTakenPillValueFromJson(
    Map<String, dynamic> json) {
  return _$_RevertTakenPillValue(
    beforeLastTakenPillNumber: json['beforeLastTakenPillNumber'] as int,
    afterLastTakenPillNumber: json['afterLastTakenPillNumber'] as int,
  );
}

Map<String, dynamic> _$_$_RevertTakenPillValueToJson(
        _$_RevertTakenPillValue instance) =>
    <String, dynamic>{
      'beforeLastTakenPillNumber': instance.beforeLastTakenPillNumber,
      'afterLastTakenPillNumber': instance.afterLastTakenPillNumber,
    };
