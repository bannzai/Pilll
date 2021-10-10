import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.dart';

part 'pill_sheet_modified_history_value.g.dart';
part 'pill_sheet_modified_history_value.freezed.dart';

@freezed
abstract class PillSheetModifiedHistoryValue
    implements _$PillSheetModifiedHistoryValue {
  PillSheetModifiedHistoryValue._();
  @JsonSerializable(explicitToJson: true)
  factory PillSheetModifiedHistoryValue({
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
  }) = _PillSheetModifiedHistoryValue;

  factory PillSheetModifiedHistoryValue.fromJson(Map<String, dynamic> json) =>
      _$PillSheetModifiedHistoryValueFromJson(json);
  Map<String, dynamic> toJson() => _$_$_PillSheetModifiedHistoryValueToJson(
      this as _$_PillSheetModifiedHistoryValue);
}

@freezed
abstract class CreatedPillSheetValue implements _$CreatedPillSheetValue {
  CreatedPillSheetValue._();
  @JsonSerializable(explicitToJson: true)
  factory CreatedPillSheetValue({
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
abstract class AutomaticallyRecordedLastTakenDateValue
    implements _$AutomaticallyRecordedLastTakenDateValue {
  AutomaticallyRecordedLastTakenDateValue._();
  @JsonSerializable(explicitToJson: true)
  factory AutomaticallyRecordedLastTakenDateValue({
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
abstract class DeletedPillSheetValue implements _$DeletedPillSheetValue {
  DeletedPillSheetValue._();
  @JsonSerializable(explicitToJson: true)
  factory DeletedPillSheetValue({
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
abstract class TakenPillValue implements _$TakenPillValue {
  TakenPillValue._();
  @JsonSerializable(explicitToJson: true)
  factory TakenPillValue({
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
abstract class RevertTakenPillValue implements _$RevertTakenPillValue {
  RevertTakenPillValue._();
  @JsonSerializable(explicitToJson: true)
  factory RevertTakenPillValue({
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
abstract class ChangedPillNumberValue implements _$ChangedPillNumberValue {
  ChangedPillNumberValue._();
  @JsonSerializable(explicitToJson: true)
  factory ChangedPillNumberValue({
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
abstract class EndedPillSheetValue implements _$EndedPillSheetValue {
  EndedPillSheetValue._();
  @JsonSerializable(explicitToJson: true)
  factory EndedPillSheetValue({
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
abstract class BeganRestDurationValue implements _$BeganRestDurationValue {
  BeganRestDurationValue._();
  @JsonSerializable(explicitToJson: true)
  factory BeganRestDurationValue({
    required RestDuration restDuration,
  }) = _BeganRestDurationValue;

  factory BeganRestDurationValue.fromJson(Map<String, dynamic> json) =>
      _$BeganRestDurationValueFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_BeganRestDurationValueToJson(this as _$_BeganRestDurationValue);
}

@freezed
abstract class EndedRestDurationValue implements _$EndedRestDurationValue {
  EndedRestDurationValue._();
  @JsonSerializable(explicitToJson: true)
  factory EndedRestDurationValue({
    required RestDuration restDuration,
  }) = _EndedRestDurationValue;

  factory EndedRestDurationValue.fromJson(Map<String, dynamic> json) =>
      _$EndedRestDurationValueFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_EndedRestDurationValueToJson(this as _$_EndedRestDurationValue);
}
