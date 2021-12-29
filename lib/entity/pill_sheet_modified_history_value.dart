import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.dart';

part 'pill_sheet_modified_history_value.g.dart';
part 'pill_sheet_modified_history_value.freezed.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class PillSheetModifiedHistoryValue with _$PillSheetModifiedHistoryValue {
  const PillSheetModifiedHistoryValue._();
  const factory PillSheetModifiedHistoryValue({
    DateTime? beginTrialDate,
    @Default(null) CreatedPillSheetValue? createdPillSheet,
    @Default(null)
        AutomaticallyRecordedLastTakenDateValue?
            automaticallyRecordedLastTakenDate,
    @Default(null) DeletedPillSheetValue? deletedPillSheet,
    @Default(null) TakenPillValue? takenPill,
    @Default(null) RevertTakenPillValue? revertTakenPill,
    @Default(null) ChangedPillNumberValue? changedPillNumber,
    @Default(null) EndedPillSheetValue? endedPillSheet,
    @Default(null) BeganRestDurationValue? beganRestDurationValue,
    @Default(null) EndedRestDurationValue? endedRestDurationValue,
  }) = _PillSheetModifiedHistoryValue;

  factory PillSheetModifiedHistoryValue.fromJson(Map<String, dynamic> json) =>
      _$PillSheetModifiedHistoryValueFromJson(json);
  Map<String, dynamic> toJson() => _$_$_PillSheetModifiedHistoryValueToJson(
      this as _$_PillSheetModifiedHistoryValue);
}

@freezed
@JsonSerializable(explicitToJson: true)
class CreatedPillSheetValue with _$CreatedPillSheetValue {
  const CreatedPillSheetValue._();
  const factory CreatedPillSheetValue({
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime pillSheetCreatedAt,
    @Default([])
        List<String> pillSheetIDs,
  }) = _CreatedPillSheetValue;

  factory CreatedPillSheetValue.fromJson(Map<String, dynamic> json) =>
      _$CreatedPillSheetValueFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_CreatedPillSheetValueToJson(this as _$_CreatedPillSheetValue);
}

@freezed
@JsonSerializable(explicitToJson: true)
class AutomaticallyRecordedLastTakenDateValue
    with _$AutomaticallyRecordedLastTakenDateValue {
  const AutomaticallyRecordedLastTakenDateValue._();
  const factory AutomaticallyRecordedLastTakenDateValue({
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? beforeLastTakenDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime afterLastTakenDate,
    required int beforeLastTakenPillNumber,
    required int afterLastTakenPillNumber,
  }) = _AutomaticallyRecordedLastTakenDateValue;

  factory AutomaticallyRecordedLastTakenDateValue.fromJson(
          Map<String, dynamic> json) =>
      _$AutomaticallyRecordedLastTakenDateValueFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_AutomaticallyRecordedLastTakenDateValueToJson(
          this as _$_AutomaticallyRecordedLastTakenDateValue);
}

@freezed
@JsonSerializable(explicitToJson: true)
class DeletedPillSheetValue with _$DeletedPillSheetValue {
  const DeletedPillSheetValue._();
  const factory DeletedPillSheetValue({
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime pillSheetDeletedAt,
    @Default([])
        List<String> pillSheetIDs,
  }) = _DeletedPillSheetValue;

  factory DeletedPillSheetValue.fromJson(Map<String, dynamic> json) =>
      _$DeletedPillSheetValueFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_DeletedPillSheetValueToJson(this as _$_DeletedPillSheetValue);
}

@freezed
@JsonSerializable(explicitToJson: true)
class TakenPillValue with _$TakenPillValue {
  const TakenPillValue._();
  const factory TakenPillValue({
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? beforeLastTakenDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime afterLastTakenDate,
    required int beforeLastTakenPillNumber,
    required int afterLastTakenPillNumber,
  }) = _TakenPillValue;

  factory TakenPillValue.fromJson(Map<String, dynamic> json) =>
      _$TakenPillValueFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_TakenPillValueToJson(this as _$_TakenPillValue);
}

@freezed
@JsonSerializable(explicitToJson: true)
class RevertTakenPillValue with _$RevertTakenPillValue {
  const RevertTakenPillValue._();
  const factory RevertTakenPillValue({
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? beforeLastTakenDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime afterLastTakenDate,
    required int beforeLastTakenPillNumber,
    required int afterLastTakenPillNumber,
  }) = _RevertTakenPillValue;

  factory RevertTakenPillValue.fromJson(Map<String, dynamic> json) =>
      _$RevertTakenPillValueFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_RevertTakenPillValueToJson(this as _$_RevertTakenPillValue);
}

@freezed
@JsonSerializable(explicitToJson: true)
class ChangedPillNumberValue with _$ChangedPillNumberValue {
  const ChangedPillNumberValue._();
  const factory ChangedPillNumberValue({
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime beforeBeginingDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime afterBeginingDate,
    required int beforeTodayPillNumber,
    required int afterTodayPillNumber,
    @Default(1)
        int beforeGroupIndex,
    @Default(1)
        int afterGroupIndex,
  }) = _ChangedPillNumberValue;

  factory ChangedPillNumberValue.fromJson(Map<String, dynamic> json) =>
      _$ChangedPillNumberValueFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_ChangedPillNumberValueToJson(this as _$_ChangedPillNumberValue);
}

@freezed
@JsonSerializable(explicitToJson: true)
class EndedPillSheetValue with _$EndedPillSheetValue {
  const EndedPillSheetValue._();
  const factory EndedPillSheetValue({
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime endRecordDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime lastTakenDate,
  }) = _EndedPillSheetValue;

  factory EndedPillSheetValue.fromJson(Map<String, dynamic> json) =>
      _$EndedPillSheetValueFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_EndedPillSheetValueToJson(this as _$_EndedPillSheetValue);
}

@freezed
@JsonSerializable(explicitToJson: true)
class BeganRestDurationValue with _$BeganRestDurationValue {
  const BeganRestDurationValue._();
  const factory BeganRestDurationValue({
    required RestDuration restDuration,
  }) = _BeganRestDurationValue;

  factory BeganRestDurationValue.fromJson(Map<String, dynamic> json) =>
      _$BeganRestDurationValueFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_BeganRestDurationValueToJson(this as _$_BeganRestDurationValue);
}

@freezed
@JsonSerializable(explicitToJson: true)
class EndedRestDurationValue with _$EndedRestDurationValue {
  const EndedRestDurationValue._();
  const factory EndedRestDurationValue({
    required RestDuration restDuration,
  }) = _EndedRestDurationValue;

  factory EndedRestDurationValue.fromJson(Map<String, dynamic> json) =>
      _$EndedRestDurationValueFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_EndedRestDurationValueToJson(this as _$_EndedRestDurationValue);
}
