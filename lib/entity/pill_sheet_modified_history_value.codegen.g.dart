// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill_sheet_modified_history_value.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PillSheetModifiedHistoryValueImpl
_$$PillSheetModifiedHistoryValueImplFromJson(Map<String, dynamic> json) =>
    _$PillSheetModifiedHistoryValueImpl(
      createdPillSheet: json['createdPillSheet'] == null
          ? null
          : CreatedPillSheetValue.fromJson(
              json['createdPillSheet'] as Map<String, dynamic>,
            ),
      automaticallyRecordedLastTakenDate:
          json['automaticallyRecordedLastTakenDate'] == null
          ? null
          : AutomaticallyRecordedLastTakenDateValue.fromJson(
              json['automaticallyRecordedLastTakenDate']
                  as Map<String, dynamic>,
            ),
      deletedPillSheet: json['deletedPillSheet'] == null
          ? null
          : DeletedPillSheetValue.fromJson(
              json['deletedPillSheet'] as Map<String, dynamic>,
            ),
      takenPill: json['takenPill'] == null
          ? null
          : TakenPillValue.fromJson(json['takenPill'] as Map<String, dynamic>),
      revertTakenPill: json['revertTakenPill'] == null
          ? null
          : RevertTakenPillValue.fromJson(
              json['revertTakenPill'] as Map<String, dynamic>,
            ),
      changedPillNumber: json['changedPillNumber'] == null
          ? null
          : ChangedPillNumberValue.fromJson(
              json['changedPillNumber'] as Map<String, dynamic>,
            ),
      endedPillSheet: json['endedPillSheet'] == null
          ? null
          : EndedPillSheetValue.fromJson(
              json['endedPillSheet'] as Map<String, dynamic>,
            ),
      beganRestDurationValue: json['beganRestDurationValue'] == null
          ? null
          : BeganRestDurationValue.fromJson(
              json['beganRestDurationValue'] as Map<String, dynamic>,
            ),
      endedRestDurationValue: json['endedRestDurationValue'] == null
          ? null
          : EndedRestDurationValue.fromJson(
              json['endedRestDurationValue'] as Map<String, dynamic>,
            ),
      changedRestDurationBeginDateValue:
          json['changedRestDurationBeginDateValue'] == null
          ? null
          : ChangedRestDurationBeginDateValue.fromJson(
              json['changedRestDurationBeginDateValue'] as Map<String, dynamic>,
            ),
      changedRestDurationValue: json['changedRestDurationValue'] == null
          ? null
          : ChangedRestDurationValue.fromJson(
              json['changedRestDurationValue'] as Map<String, dynamic>,
            ),
      changedBeginDisplayNumber: json['changedBeginDisplayNumber'] == null
          ? null
          : ChangedBeginDisplayNumberValue.fromJson(
              json['changedBeginDisplayNumber'] as Map<String, dynamic>,
            ),
      changedEndDisplayNumber: json['changedEndDisplayNumber'] == null
          ? null
          : ChangedEndDisplayNumberValue.fromJson(
              json['changedEndDisplayNumber'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$PillSheetModifiedHistoryValueImplToJson(
  _$PillSheetModifiedHistoryValueImpl instance,
) => <String, dynamic>{
  'createdPillSheet': instance.createdPillSheet?.toJson(),
  'automaticallyRecordedLastTakenDate': instance
      .automaticallyRecordedLastTakenDate
      ?.toJson(),
  'deletedPillSheet': instance.deletedPillSheet?.toJson(),
  'takenPill': instance.takenPill?.toJson(),
  'revertTakenPill': instance.revertTakenPill?.toJson(),
  'changedPillNumber': instance.changedPillNumber?.toJson(),
  'endedPillSheet': instance.endedPillSheet?.toJson(),
  'beganRestDurationValue': instance.beganRestDurationValue?.toJson(),
  'endedRestDurationValue': instance.endedRestDurationValue?.toJson(),
  'changedRestDurationBeginDateValue': instance
      .changedRestDurationBeginDateValue
      ?.toJson(),
  'changedRestDurationValue': instance.changedRestDurationValue?.toJson(),
  'changedBeginDisplayNumber': instance.changedBeginDisplayNumber?.toJson(),
  'changedEndDisplayNumber': instance.changedEndDisplayNumber?.toJson(),
};

_$CreatedPillSheetValueImpl _$$CreatedPillSheetValueImplFromJson(
  Map<String, dynamic> json,
) => _$CreatedPillSheetValueImpl();

Map<String, dynamic> _$$CreatedPillSheetValueImplToJson(
  _$CreatedPillSheetValueImpl instance,
) => <String, dynamic>{};

_$AutomaticallyRecordedLastTakenDateValueImpl
_$$AutomaticallyRecordedLastTakenDateValueImplFromJson(
  Map<String, dynamic> json,
) => _$AutomaticallyRecordedLastTakenDateValueImpl();

Map<String, dynamic> _$$AutomaticallyRecordedLastTakenDateValueImplToJson(
  _$AutomaticallyRecordedLastTakenDateValueImpl instance,
) => <String, dynamic>{};

_$DeletedPillSheetValueImpl _$$DeletedPillSheetValueImplFromJson(
  Map<String, dynamic> json,
) => _$DeletedPillSheetValueImpl();

Map<String, dynamic> _$$DeletedPillSheetValueImplToJson(
  _$DeletedPillSheetValueImpl instance,
) => <String, dynamic>{};

_$TakenPillValueImpl _$$TakenPillValueImplFromJson(Map<String, dynamic> json) =>
    _$TakenPillValueImpl(
      isQuickRecord: json['isQuickRecord'] as bool?,
      edited: json['edited'] == null
          ? null
          : TakenPillEditedValue.fromJson(
              json['edited'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$TakenPillValueImplToJson(
  _$TakenPillValueImpl instance,
) => <String, dynamic>{
  'isQuickRecord': instance.isQuickRecord,
  'edited': instance.edited?.toJson(),
};

_$TakenPillEditedValueImpl _$$TakenPillEditedValueImplFromJson(
  Map<String, dynamic> json,
) => _$TakenPillEditedValueImpl(
  actualTakenDate: NonNullTimestampConverter.timestampToDateTime(
    json['actualTakenDate'] as Timestamp,
  ),
  historyRecordedDate: NonNullTimestampConverter.timestampToDateTime(
    json['historyRecordedDate'] as Timestamp,
  ),
  createdDate: NonNullTimestampConverter.timestampToDateTime(
    json['createdDate'] as Timestamp,
  ),
);

Map<String, dynamic> _$$TakenPillEditedValueImplToJson(
  _$TakenPillEditedValueImpl instance,
) => <String, dynamic>{
  'actualTakenDate': NonNullTimestampConverter.dateTimeToTimestamp(
    instance.actualTakenDate,
  ),
  'historyRecordedDate': NonNullTimestampConverter.dateTimeToTimestamp(
    instance.historyRecordedDate,
  ),
  'createdDate': NonNullTimestampConverter.dateTimeToTimestamp(
    instance.createdDate,
  ),
};

_$RevertTakenPillValueImpl _$$RevertTakenPillValueImplFromJson(
  Map<String, dynamic> json,
) => _$RevertTakenPillValueImpl();

Map<String, dynamic> _$$RevertTakenPillValueImplToJson(
  _$RevertTakenPillValueImpl instance,
) => <String, dynamic>{};

_$ChangedPillNumberValueImpl _$$ChangedPillNumberValueImplFromJson(
  Map<String, dynamic> json,
) => _$ChangedPillNumberValueImpl();

Map<String, dynamic> _$$ChangedPillNumberValueImplToJson(
  _$ChangedPillNumberValueImpl instance,
) => <String, dynamic>{};

_$EndedPillSheetValueImpl _$$EndedPillSheetValueImplFromJson(
  Map<String, dynamic> json,
) => _$EndedPillSheetValueImpl(
  endRecordDate: NonNullTimestampConverter.timestampToDateTime(
    json['endRecordDate'] as Timestamp,
  ),
  lastTakenDate: NonNullTimestampConverter.timestampToDateTime(
    json['lastTakenDate'] as Timestamp,
  ),
);

Map<String, dynamic> _$$EndedPillSheetValueImplToJson(
  _$EndedPillSheetValueImpl instance,
) => <String, dynamic>{
  'endRecordDate': NonNullTimestampConverter.dateTimeToTimestamp(
    instance.endRecordDate,
  ),
  'lastTakenDate': NonNullTimestampConverter.dateTimeToTimestamp(
    instance.lastTakenDate,
  ),
};

_$BeganRestDurationValueImpl _$$BeganRestDurationValueImplFromJson(
  Map<String, dynamic> json,
) => _$BeganRestDurationValueImpl(
  restDuration: RestDuration.fromJson(
    json['restDuration'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$BeganRestDurationValueImplToJson(
  _$BeganRestDurationValueImpl instance,
) => <String, dynamic>{'restDuration': instance.restDuration.toJson()};

_$EndedRestDurationValueImpl _$$EndedRestDurationValueImplFromJson(
  Map<String, dynamic> json,
) => _$EndedRestDurationValueImpl(
  restDuration: RestDuration.fromJson(
    json['restDuration'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$EndedRestDurationValueImplToJson(
  _$EndedRestDurationValueImpl instance,
) => <String, dynamic>{'restDuration': instance.restDuration.toJson()};

_$ChangedRestDurationBeginDateValueImpl
_$$ChangedRestDurationBeginDateValueImplFromJson(Map<String, dynamic> json) =>
    _$ChangedRestDurationBeginDateValueImpl(
      beforeRestDuration: RestDuration.fromJson(
        json['beforeRestDuration'] as Map<String, dynamic>,
      ),
      afterRestDuration: RestDuration.fromJson(
        json['afterRestDuration'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$ChangedRestDurationBeginDateValueImplToJson(
  _$ChangedRestDurationBeginDateValueImpl instance,
) => <String, dynamic>{
  'beforeRestDuration': instance.beforeRestDuration.toJson(),
  'afterRestDuration': instance.afterRestDuration.toJson(),
};

_$ChangedRestDurationValueImpl _$$ChangedRestDurationValueImplFromJson(
  Map<String, dynamic> json,
) => _$ChangedRestDurationValueImpl(
  beforeRestDuration: RestDuration.fromJson(
    json['beforeRestDuration'] as Map<String, dynamic>,
  ),
  afterRestDuration: RestDuration.fromJson(
    json['afterRestDuration'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$ChangedRestDurationValueImplToJson(
  _$ChangedRestDurationValueImpl instance,
) => <String, dynamic>{
  'beforeRestDuration': instance.beforeRestDuration.toJson(),
  'afterRestDuration': instance.afterRestDuration.toJson(),
};

_$ChangedBeginDisplayNumberValueImpl
_$$ChangedBeginDisplayNumberValueImplFromJson(Map<String, dynamic> json) =>
    _$ChangedBeginDisplayNumberValueImpl();

Map<String, dynamic> _$$ChangedBeginDisplayNumberValueImplToJson(
  _$ChangedBeginDisplayNumberValueImpl instance,
) => <String, dynamic>{};

_$ChangedEndDisplayNumberValueImpl _$$ChangedEndDisplayNumberValueImplFromJson(
  Map<String, dynamic> json,
) => _$ChangedEndDisplayNumberValueImpl();

Map<String, dynamic> _$$ChangedEndDisplayNumberValueImplToJson(
  _$ChangedEndDisplayNumberValueImpl instance,
) => <String, dynamic>{};
