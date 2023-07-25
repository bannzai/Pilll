// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history_value.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillSheetModifiedHistoryValue _$$_PillSheetModifiedHistoryValueFromJson(
        Map<String, dynamic> json) =>
    _$_PillSheetModifiedHistoryValue(
      version: json['version'] ?? "v2",
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
      beganRestDurationValue: json['beganRestDurationValue'] == null
          ? null
          : BeganRestDurationValue.fromJson(
              json['beganRestDurationValue'] as Map<String, dynamic>),
      endedRestDurationValue: json['endedRestDurationValue'] == null
          ? null
          : EndedRestDurationValue.fromJson(
              json['endedRestDurationValue'] as Map<String, dynamic>),
      changedBeginDisplayNumber: json['changedBeginDisplayNumber'] == null
          ? null
          : ChangedBeginDisplayNumberValue.fromJson(
              json['changedBeginDisplayNumber'] as Map<String, dynamic>),
      changedEndDisplayNumber: json['changedEndDisplayNumber'] == null
          ? null
          : ChangedEndDisplayNumberValue.fromJson(
              json['changedEndDisplayNumber'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_PillSheetModifiedHistoryValueToJson(
        _$_PillSheetModifiedHistoryValue instance) =>
    <String, dynamic>{
      'version': instance.version,
      'createdPillSheet': instance.createdPillSheet?.toJson(),
      'automaticallyRecordedLastTakenDate':
          instance.automaticallyRecordedLastTakenDate?.toJson(),
      'deletedPillSheet': instance.deletedPillSheet?.toJson(),
      'takenPill': instance.takenPill?.toJson(),
      'revertTakenPill': instance.revertTakenPill?.toJson(),
      'changedPillNumber': instance.changedPillNumber?.toJson(),
      'endedPillSheet': instance.endedPillSheet?.toJson(),
      'beganRestDurationValue': instance.beganRestDurationValue?.toJson(),
      'endedRestDurationValue': instance.endedRestDurationValue?.toJson(),
      'changedBeginDisplayNumber': instance.changedBeginDisplayNumber?.toJson(),
      'changedEndDisplayNumber': instance.changedEndDisplayNumber?.toJson(),
    };

_$_CreatedPillSheetValue _$$_CreatedPillSheetValueFromJson(
        Map<String, dynamic> json) =>
    _$_CreatedPillSheetValue(
      pillSheetCreatedAt: NonNullTimestampConverter.timestampToDateTime(
          json['pillSheetCreatedAt'] as Timestamp),
      pillSheetIDs: (json['pillSheetIDs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_CreatedPillSheetValueToJson(
        _$_CreatedPillSheetValue instance) =>
    <String, dynamic>{
      'pillSheetCreatedAt': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.pillSheetCreatedAt),
      'pillSheetIDs': instance.pillSheetIDs,
    };

_$_AutomaticallyRecordedLastTakenDateValue
    _$$_AutomaticallyRecordedLastTakenDateValueFromJson(
            Map<String, dynamic> json) =>
        _$_AutomaticallyRecordedLastTakenDateValue(
          beforeLastTakenDate: TimestampConverter.timestampToDateTime(
              json['beforeLastTakenDate'] as Timestamp?),
          afterLastTakenDate: NonNullTimestampConverter.timestampToDateTime(
              json['afterLastTakenDate'] as Timestamp),
          beforeLastTakenPillNumber: json['beforeLastTakenPillNumber'] as int,
          afterLastTakenPillNumber: json['afterLastTakenPillNumber'] as int,
        );

Map<String, dynamic> _$$_AutomaticallyRecordedLastTakenDateValueToJson(
        _$_AutomaticallyRecordedLastTakenDateValue instance) =>
    <String, dynamic>{
      'beforeLastTakenDate':
          TimestampConverter.dateTimeToTimestamp(instance.beforeLastTakenDate),
      'afterLastTakenDate': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.afterLastTakenDate),
      'beforeLastTakenPillNumber': instance.beforeLastTakenPillNumber,
      'afterLastTakenPillNumber': instance.afterLastTakenPillNumber,
    };

_$_DeletedPillSheetValue _$$_DeletedPillSheetValueFromJson(
        Map<String, dynamic> json) =>
    _$_DeletedPillSheetValue(
      pillSheetDeletedAt: NonNullTimestampConverter.timestampToDateTime(
          json['pillSheetDeletedAt'] as Timestamp),
      pillSheetIDs: (json['pillSheetIDs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_DeletedPillSheetValueToJson(
        _$_DeletedPillSheetValue instance) =>
    <String, dynamic>{
      'pillSheetDeletedAt': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.pillSheetDeletedAt),
      'pillSheetIDs': instance.pillSheetIDs,
    };

_$_TakenPillValue _$$_TakenPillValueFromJson(Map<String, dynamic> json) =>
    _$_TakenPillValue(
      beforeLastTakenDate: TimestampConverter.timestampToDateTime(
          json['beforeLastTakenDate'] as Timestamp?),
      afterLastTakenDate: NonNullTimestampConverter.timestampToDateTime(
          json['afterLastTakenDate'] as Timestamp),
      beforeLastTakenPillNumber: json['beforeLastTakenPillNumber'] as int,
      afterLastTakenPillNumber: json['afterLastTakenPillNumber'] as int,
      isQuickRecord: json['isQuickRecord'] as bool?,
      edited: json['edited'] == null
          ? null
          : TakenPillEditedValue.fromJson(
              json['edited'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_TakenPillValueToJson(_$_TakenPillValue instance) =>
    <String, dynamic>{
      'beforeLastTakenDate':
          TimestampConverter.dateTimeToTimestamp(instance.beforeLastTakenDate),
      'afterLastTakenDate': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.afterLastTakenDate),
      'beforeLastTakenPillNumber': instance.beforeLastTakenPillNumber,
      'afterLastTakenPillNumber': instance.afterLastTakenPillNumber,
      'isQuickRecord': instance.isQuickRecord,
      'edited': instance.edited?.toJson(),
    };

_$_TakenPillEditedValue _$$_TakenPillEditedValueFromJson(
        Map<String, dynamic> json) =>
    _$_TakenPillEditedValue(
      createdDate: NonNullTimestampConverter.timestampToDateTime(
          json['createdDate'] as Timestamp),
      actualTakenDate: NonNullTimestampConverter.timestampToDateTime(
          json['actualTakenDate'] as Timestamp),
      historyRecordedDate: NonNullTimestampConverter.timestampToDateTime(
          json['historyRecordedDate'] as Timestamp),
    );

Map<String, dynamic> _$$_TakenPillEditedValueToJson(
        _$_TakenPillEditedValue instance) =>
    <String, dynamic>{
      'createdDate':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDate),
      'actualTakenDate': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.actualTakenDate),
      'historyRecordedDate': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.historyRecordedDate),
    };

_$_RevertTakenPillValue _$$_RevertTakenPillValueFromJson(
        Map<String, dynamic> json) =>
    _$_RevertTakenPillValue(
      beforeLastTakenDate: TimestampConverter.timestampToDateTime(
          json['beforeLastTakenDate'] as Timestamp?),
      afterLastTakenDate: NonNullTimestampConverter.timestampToDateTime(
          json['afterLastTakenDate'] as Timestamp),
      beforeLastTakenPillNumber: json['beforeLastTakenPillNumber'] as int,
      afterLastTakenPillNumber: json['afterLastTakenPillNumber'] as int,
    );

Map<String, dynamic> _$$_RevertTakenPillValueToJson(
        _$_RevertTakenPillValue instance) =>
    <String, dynamic>{
      'beforeLastTakenDate':
          TimestampConverter.dateTimeToTimestamp(instance.beforeLastTakenDate),
      'afterLastTakenDate': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.afterLastTakenDate),
      'beforeLastTakenPillNumber': instance.beforeLastTakenPillNumber,
      'afterLastTakenPillNumber': instance.afterLastTakenPillNumber,
    };

_$_ChangedPillNumberValue _$$_ChangedPillNumberValueFromJson(
        Map<String, dynamic> json) =>
    _$_ChangedPillNumberValue(
      beforeBeginingDate: NonNullTimestampConverter.timestampToDateTime(
          json['beforeBeginingDate'] as Timestamp),
      afterBeginingDate: NonNullTimestampConverter.timestampToDateTime(
          json['afterBeginingDate'] as Timestamp),
      beforeTodayPillNumber: json['beforeTodayPillNumber'] as int,
      afterTodayPillNumber: json['afterTodayPillNumber'] as int,
      beforeGroupIndex: json['beforeGroupIndex'] as int? ?? 1,
      afterGroupIndex: json['afterGroupIndex'] as int? ?? 1,
    );

Map<String, dynamic> _$$_ChangedPillNumberValueToJson(
        _$_ChangedPillNumberValue instance) =>
    <String, dynamic>{
      'beforeBeginingDate': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.beforeBeginingDate),
      'afterBeginingDate': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.afterBeginingDate),
      'beforeTodayPillNumber': instance.beforeTodayPillNumber,
      'afterTodayPillNumber': instance.afterTodayPillNumber,
      'beforeGroupIndex': instance.beforeGroupIndex,
      'afterGroupIndex': instance.afterGroupIndex,
    };

_$_EndedPillSheetValue _$$_EndedPillSheetValueFromJson(
        Map<String, dynamic> json) =>
    _$_EndedPillSheetValue(
      endRecordDate: NonNullTimestampConverter.timestampToDateTime(
          json['endRecordDate'] as Timestamp),
      lastTakenDate: NonNullTimestampConverter.timestampToDateTime(
          json['lastTakenDate'] as Timestamp),
    );

Map<String, dynamic> _$$_EndedPillSheetValueToJson(
        _$_EndedPillSheetValue instance) =>
    <String, dynamic>{
      'endRecordDate':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.endRecordDate),
      'lastTakenDate':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.lastTakenDate),
    };

_$_BeganRestDurationValue _$$_BeganRestDurationValueFromJson(
        Map<String, dynamic> json) =>
    _$_BeganRestDurationValue(
      restDuration:
          RestDuration.fromJson(json['restDuration'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_BeganRestDurationValueToJson(
        _$_BeganRestDurationValue instance) =>
    <String, dynamic>{
      'restDuration': instance.restDuration.toJson(),
    };

_$_EndedRestDurationValue _$$_EndedRestDurationValueFromJson(
        Map<String, dynamic> json) =>
    _$_EndedRestDurationValue(
      restDuration:
          RestDuration.fromJson(json['restDuration'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_EndedRestDurationValueToJson(
        _$_EndedRestDurationValue instance) =>
    <String, dynamic>{
      'restDuration': instance.restDuration.toJson(),
    };

_$_ChangedBeginDisplayNumberValue _$$_ChangedBeginDisplayNumberValueFromJson(
        Map<String, dynamic> json) =>
    _$_ChangedBeginDisplayNumberValue(
      beforeDisplayNumberSetting: json['beforeDisplayNumberSetting'] == null
          ? null
          : PillSheetGroupDisplayNumberSetting.fromJson(
              json['beforeDisplayNumberSetting'] as Map<String, dynamic>),
      afterDisplayNumberSetting: PillSheetGroupDisplayNumberSetting.fromJson(
          json['afterDisplayNumberSetting'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ChangedBeginDisplayNumberValueToJson(
        _$_ChangedBeginDisplayNumberValue instance) =>
    <String, dynamic>{
      'beforeDisplayNumberSetting':
          instance.beforeDisplayNumberSetting?.toJson(),
      'afterDisplayNumberSetting': instance.afterDisplayNumberSetting.toJson(),
    };

_$_ChangedEndDisplayNumberValue _$$_ChangedEndDisplayNumberValueFromJson(
        Map<String, dynamic> json) =>
    _$_ChangedEndDisplayNumberValue(
      beforeDisplayNumberSetting: json['beforeDisplayNumberSetting'] == null
          ? null
          : PillSheetGroupDisplayNumberSetting.fromJson(
              json['beforeDisplayNumberSetting'] as Map<String, dynamic>),
      afterDisplayNumberSetting: PillSheetGroupDisplayNumberSetting.fromJson(
          json['afterDisplayNumberSetting'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ChangedEndDisplayNumberValueToJson(
        _$_ChangedEndDisplayNumberValue instance) =>
    <String, dynamic>{
      'beforeDisplayNumberSetting':
          instance.beforeDisplayNumberSetting?.toJson(),
      'afterDisplayNumberSetting': instance.afterDisplayNumberSetting.toJson(),
    };
