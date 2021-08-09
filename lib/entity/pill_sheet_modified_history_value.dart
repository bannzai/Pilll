import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';

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
            automaticallyRecordedLastTakenDateValue,
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
