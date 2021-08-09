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
    automaticallyRecordedLastTakenDate:
        json['automaticallyRecordedLastTakenDate'] == null
            ? null
            : AutomaticallyRecordedLastTakenDateValue.fromJson(
                json['automaticallyRecordedLastTakenDate']
                    as Map<String, dynamic>),
    deletedPillSheet: json['deletedPillSheet'] == null
        ? null
        : DeletedPillSheetValue.fromJson(
            json['deletedPillSheet'] as Map<String, dynamic>),
    takenPill: json['takenPill'] == null
        ? null
        : TakenPillValue.fromJson(json['takenPill'] as Map<String, dynamic>),
    revertTakenPill: json['revertTakenPill'] == null
        ? null
        : RevertTakenPillValue.fromJson(
            json['revertTakenPill'] as Map<String, dynamic>),
    changedPillNumber: json['changedPillNumber'] == null
        ? null
        : ChangedPillNumberValue.fromJson(
            json['changedPillNumber'] as Map<String, dynamic>),
    endedPillSheet: json['endedPillSheet'] == null
        ? null
        : EndedPillSheetValue.fromJson(
            json['endedPillSheet'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_$_PillSheetModifiedHistoryValueToJson(
        _$_PillSheetModifiedHistoryValue instance) =>
    <String, dynamic>{
      'beginTrialDate': instance.beginTrialDate?.toIso8601String(),
      'createdPillSheet': instance.createdPillSheet?.toJson(),
      'automaticallyRecordedLastTakenDate':
          instance.automaticallyRecordedLastTakenDate?.toJson(),
      'deletedPillSheet': instance.deletedPillSheet?.toJson(),
      'takenPill': instance.takenPill?.toJson(),
      'revertTakenPill': instance.revertTakenPill?.toJson(),
      'changedPillNumber': instance.changedPillNumber?.toJson(),
      'endedPillSheet': instance.endedPillSheet?.toJson(),
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

_$_ChangedPillNumberValue _$_$_ChangedPillNumberValueFromJson(
    Map<String, dynamic> json) {
  return _$_ChangedPillNumberValue(
    beforeBeginingDate: NonNullTimestampConverter.timestampToDateTime(
        json['beforeBeginingDate'] as Timestamp),
    afterBeginingDate: NonNullTimestampConverter.timestampToDateTime(
        json['afterBeginingDate'] as Timestamp),
    beforeLastTakenPillNumber: json['beforeLastTakenPillNumber'] as int?,
    afterLastTakenPillNumber: json['afterLastTakenPillNumber'] as int,
  );
}

Map<String, dynamic> _$_$_ChangedPillNumberValueToJson(
        _$_ChangedPillNumberValue instance) =>
    <String, dynamic>{
      'beforeBeginingDate': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.beforeBeginingDate),
      'afterBeginingDate': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.afterBeginingDate),
      'beforeLastTakenPillNumber': instance.beforeLastTakenPillNumber,
      'afterLastTakenPillNumber': instance.afterLastTakenPillNumber,
    };

_$_EndedPillSheetValue _$_$_EndedPillSheetValueFromJson(
    Map<String, dynamic> json) {
  return _$_EndedPillSheetValue(
    afterLastTakenDate: NonNullTimestampConverter.timestampToDateTime(
        json['afterLastTakenDate'] as Timestamp),
  );
}

Map<String, dynamic> _$_$_EndedPillSheetValueToJson(
        _$_EndedPillSheetValue instance) =>
    <String, dynamic>{
      'afterLastTakenDate': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.afterLastTakenDate),
    };
