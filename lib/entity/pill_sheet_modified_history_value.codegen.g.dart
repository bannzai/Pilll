// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history_value.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PillSheetModifiedHistoryValue _$PillSheetModifiedHistoryValueFromJson(Map<String, dynamic> json) => _PillSheetModifiedHistoryValue(
  createdPillSheet: json['createdPillSheet'] == null ? null : CreatedPillSheetValue.fromJson(json['createdPillSheet'] as Map<String, dynamic>),
  automaticallyRecordedLastTakenDate: json['automaticallyRecordedLastTakenDate'] == null
      ? null
      : AutomaticallyRecordedLastTakenDateValue.fromJson(json['automaticallyRecordedLastTakenDate'] as Map<String, dynamic>),
  deletedPillSheet: json['deletedPillSheet'] == null ? null : DeletedPillSheetValue.fromJson(json['deletedPillSheet'] as Map<String, dynamic>),
  takenPill: json['takenPill'] == null ? null : TakenPillValue.fromJson(json['takenPill'] as Map<String, dynamic>),
  revertTakenPill: json['revertTakenPill'] == null ? null : RevertTakenPillValue.fromJson(json['revertTakenPill'] as Map<String, dynamic>),
  changedPillNumber: json['changedPillNumber'] == null ? null : ChangedPillNumberValue.fromJson(json['changedPillNumber'] as Map<String, dynamic>),
  endedPillSheet: json['endedPillSheet'] == null ? null : EndedPillSheetValue.fromJson(json['endedPillSheet'] as Map<String, dynamic>),
  beganRestDurationValue: json['beganRestDurationValue'] == null
      ? null
      : BeganRestDurationValue.fromJson(json['beganRestDurationValue'] as Map<String, dynamic>),
  endedRestDurationValue: json['endedRestDurationValue'] == null
      ? null
      : EndedRestDurationValue.fromJson(json['endedRestDurationValue'] as Map<String, dynamic>),
  changedRestDurationBeginDateValue: json['changedRestDurationBeginDateValue'] == null
      ? null
      : ChangedRestDurationBeginDateValue.fromJson(json['changedRestDurationBeginDateValue'] as Map<String, dynamic>),
  changedRestDurationValue: json['changedRestDurationValue'] == null
      ? null
      : ChangedRestDurationValue.fromJson(json['changedRestDurationValue'] as Map<String, dynamic>),
  changedBeginDisplayNumber: json['changedBeginDisplayNumber'] == null
      ? null
      : ChangedBeginDisplayNumberValue.fromJson(json['changedBeginDisplayNumber'] as Map<String, dynamic>),
  changedEndDisplayNumber: json['changedEndDisplayNumber'] == null
      ? null
      : ChangedEndDisplayNumberValue.fromJson(json['changedEndDisplayNumber'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PillSheetModifiedHistoryValueToJson(_PillSheetModifiedHistoryValue instance) => <String, dynamic>{
  'createdPillSheet': instance.createdPillSheet?.toJson(),
  'automaticallyRecordedLastTakenDate': instance.automaticallyRecordedLastTakenDate?.toJson(),
  'deletedPillSheet': instance.deletedPillSheet?.toJson(),
  'takenPill': instance.takenPill?.toJson(),
  'revertTakenPill': instance.revertTakenPill?.toJson(),
  'changedPillNumber': instance.changedPillNumber?.toJson(),
  'endedPillSheet': instance.endedPillSheet?.toJson(),
  'beganRestDurationValue': instance.beganRestDurationValue?.toJson(),
  'endedRestDurationValue': instance.endedRestDurationValue?.toJson(),
  'changedRestDurationBeginDateValue': instance.changedRestDurationBeginDateValue?.toJson(),
  'changedRestDurationValue': instance.changedRestDurationValue?.toJson(),
  'changedBeginDisplayNumber': instance.changedBeginDisplayNumber?.toJson(),
  'changedEndDisplayNumber': instance.changedEndDisplayNumber?.toJson(),
};

_CreatedPillSheetValue _$CreatedPillSheetValueFromJson(Map<String, dynamic> json) => _CreatedPillSheetValue(
  pillSheetCreatedAt: NonNullTimestampConverter.timestampToDateTime(json['pillSheetCreatedAt'] as Timestamp),
  pillSheetIDs: (json['pillSheetIDs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
);

Map<String, dynamic> _$CreatedPillSheetValueToJson(_CreatedPillSheetValue instance) => <String, dynamic>{
  'pillSheetCreatedAt': NonNullTimestampConverter.dateTimeToTimestamp(instance.pillSheetCreatedAt),
  'pillSheetIDs': instance.pillSheetIDs,
};

_AutomaticallyRecordedLastTakenDateValue _$AutomaticallyRecordedLastTakenDateValueFromJson(Map<String, dynamic> json) =>
    _AutomaticallyRecordedLastTakenDateValue(
      beforeLastTakenDate: TimestampConverter.timestampToDateTime(json['beforeLastTakenDate'] as Timestamp?),
      afterLastTakenDate: NonNullTimestampConverter.timestampToDateTime(json['afterLastTakenDate'] as Timestamp),
      beforeLastTakenPillNumber: (json['beforeLastTakenPillNumber'] as num).toInt(),
      afterLastTakenPillNumber: (json['afterLastTakenPillNumber'] as num).toInt(),
    );

Map<String, dynamic> _$AutomaticallyRecordedLastTakenDateValueToJson(_AutomaticallyRecordedLastTakenDateValue instance) => <String, dynamic>{
  'beforeLastTakenDate': TimestampConverter.dateTimeToTimestamp(instance.beforeLastTakenDate),
  'afterLastTakenDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.afterLastTakenDate),
  'beforeLastTakenPillNumber': instance.beforeLastTakenPillNumber,
  'afterLastTakenPillNumber': instance.afterLastTakenPillNumber,
};

_DeletedPillSheetValue _$DeletedPillSheetValueFromJson(Map<String, dynamic> json) => _DeletedPillSheetValue(
  pillSheetDeletedAt: NonNullTimestampConverter.timestampToDateTime(json['pillSheetDeletedAt'] as Timestamp),
  pillSheetIDs: (json['pillSheetIDs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
);

Map<String, dynamic> _$DeletedPillSheetValueToJson(_DeletedPillSheetValue instance) => <String, dynamic>{
  'pillSheetDeletedAt': NonNullTimestampConverter.dateTimeToTimestamp(instance.pillSheetDeletedAt),
  'pillSheetIDs': instance.pillSheetIDs,
};

_TakenPillValue _$TakenPillValueFromJson(Map<String, dynamic> json) => _TakenPillValue(
  isQuickRecord: json['isQuickRecord'] as bool?,
  edited: json['edited'] == null ? null : TakenPillEditedValue.fromJson(json['edited'] as Map<String, dynamic>),
  beforeLastTakenDate: TimestampConverter.timestampToDateTime(json['beforeLastTakenDate'] as Timestamp?),
  afterLastTakenDate: NonNullTimestampConverter.timestampToDateTime(json['afterLastTakenDate'] as Timestamp),
  beforeLastTakenPillNumber: (json['beforeLastTakenPillNumber'] as num).toInt(),
  afterLastTakenPillNumber: (json['afterLastTakenPillNumber'] as num).toInt(),
);

Map<String, dynamic> _$TakenPillValueToJson(_TakenPillValue instance) => <String, dynamic>{
  'isQuickRecord': instance.isQuickRecord,
  'edited': instance.edited?.toJson(),
  'beforeLastTakenDate': TimestampConverter.dateTimeToTimestamp(instance.beforeLastTakenDate),
  'afterLastTakenDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.afterLastTakenDate),
  'beforeLastTakenPillNumber': instance.beforeLastTakenPillNumber,
  'afterLastTakenPillNumber': instance.afterLastTakenPillNumber,
};

_TakenPillEditedValue _$TakenPillEditedValueFromJson(Map<String, dynamic> json) => _TakenPillEditedValue(
  actualTakenDate: NonNullTimestampConverter.timestampToDateTime(json['actualTakenDate'] as Timestamp),
  historyRecordedDate: NonNullTimestampConverter.timestampToDateTime(json['historyRecordedDate'] as Timestamp),
  createdDate: NonNullTimestampConverter.timestampToDateTime(json['createdDate'] as Timestamp),
);

Map<String, dynamic> _$TakenPillEditedValueToJson(_TakenPillEditedValue instance) => <String, dynamic>{
  'actualTakenDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.actualTakenDate),
  'historyRecordedDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.historyRecordedDate),
  'createdDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDate),
};

_RevertTakenPillValue _$RevertTakenPillValueFromJson(Map<String, dynamic> json) => _RevertTakenPillValue(
  beforeLastTakenDate: TimestampConverter.timestampToDateTime(json['beforeLastTakenDate'] as Timestamp?),
  afterLastTakenDate: TimestampConverter.timestampToDateTime(json['afterLastTakenDate'] as Timestamp?),
  beforeLastTakenPillNumber: (json['beforeLastTakenPillNumber'] as num).toInt(),
  afterLastTakenPillNumber: (json['afterLastTakenPillNumber'] as num).toInt(),
);

Map<String, dynamic> _$RevertTakenPillValueToJson(_RevertTakenPillValue instance) => <String, dynamic>{
  'beforeLastTakenDate': TimestampConverter.dateTimeToTimestamp(instance.beforeLastTakenDate),
  'afterLastTakenDate': TimestampConverter.dateTimeToTimestamp(instance.afterLastTakenDate),
  'beforeLastTakenPillNumber': instance.beforeLastTakenPillNumber,
  'afterLastTakenPillNumber': instance.afterLastTakenPillNumber,
};

_ChangedPillNumberValue _$ChangedPillNumberValueFromJson(Map<String, dynamic> json) => _ChangedPillNumberValue(
  beforeBeginingDate: NonNullTimestampConverter.timestampToDateTime(json['beforeBeginingDate'] as Timestamp),
  afterBeginingDate: NonNullTimestampConverter.timestampToDateTime(json['afterBeginingDate'] as Timestamp),
  beforeTodayPillNumber: (json['beforeTodayPillNumber'] as num).toInt(),
  afterTodayPillNumber: (json['afterTodayPillNumber'] as num).toInt(),
  beforeGroupIndex: (json['beforeGroupIndex'] as num?)?.toInt() ?? 1,
  afterGroupIndex: (json['afterGroupIndex'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$ChangedPillNumberValueToJson(_ChangedPillNumberValue instance) => <String, dynamic>{
  'beforeBeginingDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.beforeBeginingDate),
  'afterBeginingDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.afterBeginingDate),
  'beforeTodayPillNumber': instance.beforeTodayPillNumber,
  'afterTodayPillNumber': instance.afterTodayPillNumber,
  'beforeGroupIndex': instance.beforeGroupIndex,
  'afterGroupIndex': instance.afterGroupIndex,
};

_EndedPillSheetValue _$EndedPillSheetValueFromJson(Map<String, dynamic> json) => _EndedPillSheetValue(
  endRecordDate: NonNullTimestampConverter.timestampToDateTime(json['endRecordDate'] as Timestamp),
  lastTakenDate: NonNullTimestampConverter.timestampToDateTime(json['lastTakenDate'] as Timestamp),
);

Map<String, dynamic> _$EndedPillSheetValueToJson(_EndedPillSheetValue instance) => <String, dynamic>{
  'endRecordDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.endRecordDate),
  'lastTakenDate': NonNullTimestampConverter.dateTimeToTimestamp(instance.lastTakenDate),
};

_BeganRestDurationValue _$BeganRestDurationValueFromJson(Map<String, dynamic> json) =>
    _BeganRestDurationValue(restDuration: RestDuration.fromJson(json['restDuration'] as Map<String, dynamic>));

Map<String, dynamic> _$BeganRestDurationValueToJson(_BeganRestDurationValue instance) => <String, dynamic>{
  'restDuration': instance.restDuration.toJson(),
};

_EndedRestDurationValue _$EndedRestDurationValueFromJson(Map<String, dynamic> json) =>
    _EndedRestDurationValue(restDuration: RestDuration.fromJson(json['restDuration'] as Map<String, dynamic>));

Map<String, dynamic> _$EndedRestDurationValueToJson(_EndedRestDurationValue instance) => <String, dynamic>{
  'restDuration': instance.restDuration.toJson(),
};

_ChangedRestDurationBeginDateValue _$ChangedRestDurationBeginDateValueFromJson(Map<String, dynamic> json) => _ChangedRestDurationBeginDateValue(
  beforeRestDuration: RestDuration.fromJson(json['beforeRestDuration'] as Map<String, dynamic>),
  afterRestDuration: RestDuration.fromJson(json['afterRestDuration'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChangedRestDurationBeginDateValueToJson(_ChangedRestDurationBeginDateValue instance) => <String, dynamic>{
  'beforeRestDuration': instance.beforeRestDuration.toJson(),
  'afterRestDuration': instance.afterRestDuration.toJson(),
};

_ChangedRestDurationValue _$ChangedRestDurationValueFromJson(Map<String, dynamic> json) => _ChangedRestDurationValue(
  beforeRestDuration: RestDuration.fromJson(json['beforeRestDuration'] as Map<String, dynamic>),
  afterRestDuration: RestDuration.fromJson(json['afterRestDuration'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChangedRestDurationValueToJson(_ChangedRestDurationValue instance) => <String, dynamic>{
  'beforeRestDuration': instance.beforeRestDuration.toJson(),
  'afterRestDuration': instance.afterRestDuration.toJson(),
};

_ChangedBeginDisplayNumberValue _$ChangedBeginDisplayNumberValueFromJson(Map<String, dynamic> json) => _ChangedBeginDisplayNumberValue(
  beforeDisplayNumberSetting: json['beforeDisplayNumberSetting'] == null
      ? null
      : PillSheetGroupDisplayNumberSetting.fromJson(json['beforeDisplayNumberSetting'] as Map<String, dynamic>),
  afterDisplayNumberSetting: PillSheetGroupDisplayNumberSetting.fromJson(json['afterDisplayNumberSetting'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChangedBeginDisplayNumberValueToJson(_ChangedBeginDisplayNumberValue instance) => <String, dynamic>{
  'beforeDisplayNumberSetting': instance.beforeDisplayNumberSetting?.toJson(),
  'afterDisplayNumberSetting': instance.afterDisplayNumberSetting.toJson(),
};

_ChangedEndDisplayNumberValue _$ChangedEndDisplayNumberValueFromJson(Map<String, dynamic> json) => _ChangedEndDisplayNumberValue(
  beforeDisplayNumberSetting: json['beforeDisplayNumberSetting'] == null
      ? null
      : PillSheetGroupDisplayNumberSetting.fromJson(json['beforeDisplayNumberSetting'] as Map<String, dynamic>),
  afterDisplayNumberSetting: PillSheetGroupDisplayNumberSetting.fromJson(json['afterDisplayNumberSetting'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChangedEndDisplayNumberValueToJson(_ChangedEndDisplayNumberValue instance) => <String, dynamic>{
  'beforeDisplayNumberSetting': instance.beforeDisplayNumberSetting?.toJson(),
  'afterDisplayNumberSetting': instance.afterDisplayNumberSetting.toJson(),
};
