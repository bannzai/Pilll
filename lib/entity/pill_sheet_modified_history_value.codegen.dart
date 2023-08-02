import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

part 'pill_sheet_modified_history_value.codegen.g.dart';
part 'pill_sheet_modified_history_value.codegen.freezed.dart';

@freezed
class PillSheetModifiedHistoryValue with _$PillSheetModifiedHistoryValue {
  const PillSheetModifiedHistoryValue._();
  @JsonSerializable(explicitToJson: true)
  const factory PillSheetModifiedHistoryValue({
    @Default(null) CreatedPillSheetValue? createdPillSheet,
    @Default(null) AutomaticallyRecordedLastTakenDateValue? automaticallyRecordedLastTakenDate,
    @Default(null) DeletedPillSheetValue? deletedPillSheet,
    @Default(null) TakenPillValue? takenPill,
    @Default(null) RevertTakenPillValue? revertTakenPill,
    @Default(null) ChangedPillNumberValue? changedPillNumber,
    @Default(null) EndedPillSheetValue? endedPillSheet,
    @Default(null) BeganRestDurationValue? beganRestDurationValue,
    @Default(null) EndedRestDurationValue? endedRestDurationValue,
    @Default(null) ChangedBeginDisplayNumberValue? changedBeginDisplayNumber,
    @Default(null) ChangedEndDisplayNumberValue? changedEndDisplayNumber,
  }) = _PillSheetModifiedHistoryValue;

  factory PillSheetModifiedHistoryValue.fromJson(Map<String, dynamic> json) => _$PillSheetModifiedHistoryValueFromJson(json);
}

@freezed
class CreatedPillSheetValue with _$CreatedPillSheetValue {
  const CreatedPillSheetValue._();
  @JsonSerializable(explicitToJson: true)
  const factory CreatedPillSheetValue({
    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: delete after 2024-03-01
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime pillSheetCreatedAt,
    @Default([]) List<String> pillSheetIDs,
  }) = _CreatedPillSheetValue;

  factory CreatedPillSheetValue.fromJson(Map<String, dynamic> json) => _$CreatedPillSheetValueFromJson(json);
}

@freezed
class AutomaticallyRecordedLastTakenDateValue with _$AutomaticallyRecordedLastTakenDateValue {
  const AutomaticallyRecordedLastTakenDateValue._();
  @JsonSerializable(explicitToJson: true)
  const factory AutomaticallyRecordedLastTakenDateValue({
    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: delete after 2024-03-01
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

  factory AutomaticallyRecordedLastTakenDateValue.fromJson(Map<String, dynamic> json) => _$AutomaticallyRecordedLastTakenDateValueFromJson(json);
}

@freezed
class DeletedPillSheetValue with _$DeletedPillSheetValue {
  const DeletedPillSheetValue._();
  @JsonSerializable(explicitToJson: true)
  const factory DeletedPillSheetValue({
    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: delete after 2024-03-01
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime pillSheetDeletedAt,
    @Default([]) List<String> pillSheetIDs,
  }) = _DeletedPillSheetValue;

  factory DeletedPillSheetValue.fromJson(Map<String, dynamic> json) => _$DeletedPillSheetValueFromJson(json);
}

@freezed
class TakenPillValue with _$TakenPillValue {
  const TakenPillValue._();
  @JsonSerializable(explicitToJson: true)
  const factory TakenPillValue({
    // ============ BEGIN: Added since v1 ============
    // null => 途中から追加したプロパティなので、どちらか不明
    bool? isQuickRecord,
    TakenPillEditedValue? edited,
    // ============ END: Added since v1 ============

    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: delete after 2024-03-01
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

  factory TakenPillValue.fromJson(Map<String, dynamic> json) => _$TakenPillValueFromJson(json);
}

@freezed
class TakenPillEditedValue with _$TakenPillEditedValue {
  @JsonSerializable(explicitToJson: true)
  const factory TakenPillEditedValue({
    // ============ BEGIN: Added since v1 ============
    // 実際の服用時刻。ユーザーが編集した後の服用時刻
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime actualTakenDate,
    // 元々の履歴がDBに書き込まれた時刻。通常はユーザーが編集する前の服用時刻
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime historyRecordedDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime createdDate,
    // ============ END: Added since v1 ============
  }) = _TakenPillEditedValue;
  const TakenPillEditedValue._();

  factory TakenPillEditedValue.fromJson(Map<String, dynamic> json) => _$TakenPillEditedValueFromJson(json);
}

@freezed
class RevertTakenPillValue with _$RevertTakenPillValue {
  const RevertTakenPillValue._();
  @JsonSerializable(explicitToJson: true)
  const factory RevertTakenPillValue({
    // The below properties are deprecated and added since v1.
   // This is deprecated property. TODO: delete after 2024-03-01
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

  factory RevertTakenPillValue.fromJson(Map<String, dynamic> json) => _$RevertTakenPillValueFromJson(json);
}

@freezed
class ChangedPillNumberValue with _$ChangedPillNumberValue {
  const ChangedPillNumberValue._();
  @JsonSerializable(explicitToJson: true)
  const factory ChangedPillNumberValue({
    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: delete after 2024-03-01
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
    @Default(1) int beforeGroupIndex,
    @Default(1) int afterGroupIndex,
  }) = _ChangedPillNumberValue;

  factory ChangedPillNumberValue.fromJson(Map<String, dynamic> json) => _$ChangedPillNumberValueFromJson(json);
}

@freezed
class EndedPillSheetValue with _$EndedPillSheetValue {
  const EndedPillSheetValue._();
  @JsonSerializable(explicitToJson: true)
  const factory EndedPillSheetValue({
    // 終了した日付。サーバーで書き込まれる
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime endRecordDate,
    // 終了した時点での最終服用日
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime lastTakenDate,
  }) = _EndedPillSheetValue;

  factory EndedPillSheetValue.fromJson(Map<String, dynamic> json) => _$EndedPillSheetValueFromJson(json);
}

@freezed
class BeganRestDurationValue with _$BeganRestDurationValue {
  const BeganRestDurationValue._();
  @JsonSerializable(explicitToJson: true)
  const factory BeganRestDurationValue({
    // ============ BEGIN: Added since v1 ============
    // どの服用お休み期間か特定するのが大変なので記録したものを使用する
    required RestDuration restDuration,
    // ============ END: Added since v1 ============
  }) = _BeganRestDurationValue;

  factory BeganRestDurationValue.fromJson(Map<String, dynamic> json) => _$BeganRestDurationValueFromJson(json);
}

@freezed
class EndedRestDurationValue with _$EndedRestDurationValue {
  const EndedRestDurationValue._();
  @JsonSerializable(explicitToJson: true)
  const factory EndedRestDurationValue({
    // ============ BEGIN: Added since v1 ============
    // どの服用お休み期間か特定するのが大変なので記録したものを使用する
    required RestDuration restDuration,
    // ============ END: Added since v1 ============
  }) = _EndedRestDurationValue;

  factory EndedRestDurationValue.fromJson(Map<String, dynamic> json) => _$EndedRestDurationValueFromJson(json);
}

@freezed
class ChangedBeginDisplayNumberValue with _$ChangedBeginDisplayNumberValue {
  const ChangedBeginDisplayNumberValue._();
  @JsonSerializable(explicitToJson: true)
  const factory ChangedBeginDisplayNumberValue({
    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: delete after 2024-03-01
    // 番号を変更した事が無い場合もあるのでnullable
    required PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting,
    required PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting,
  }) = _ChangedBeginDisplayNumberValue;

  factory ChangedBeginDisplayNumberValue.fromJson(Map<String, dynamic> json) => _$ChangedBeginDisplayNumberValueFromJson(json);
}

@freezed
class ChangedEndDisplayNumberValue with _$ChangedEndDisplayNumberValue {
  const ChangedEndDisplayNumberValue._();
  @JsonSerializable(explicitToJson: true)
  const factory ChangedEndDisplayNumberValue({
    // The below properties are deprecated and added since v1.
    // This is deprecated property. TODO: delete after 2024-03-01
    // 番号を変更した事が無い場合もあるのでnullable
    required PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting,
    required PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting,
  }) = _ChangedEndDisplayNumberValue;

  factory ChangedEndDisplayNumberValue.fromJson(Map<String, dynamic> json) => _$ChangedEndDisplayNumberValueFromJson(json);
}
