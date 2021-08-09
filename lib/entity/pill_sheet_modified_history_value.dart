import 'package:freezed_annotation/freezed_annotation.dart';

part 'pill_sheet_modified_history_value.g.dart';
part 'pill_sheet_modified_history_value.freezed.dart';

@freezed
abstract class PillSheetModifiedHistoryValue
    implements _$PillSheetModifiedHistoryValue {
  PillSheetModifiedHistoryValue._();
  @JsonSerializable(explicitToJson: true)
  factory PillSheetModifiedHistoryValue({
    DateTime? beginTrialDate,
    @Default(null) CreatedPillSheetValue createdPillSheet,
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
    DateTime? beginTrialDate,
    @Default(false) bool isTrial,
    @Default(false) bool isPremium,
    @Default(false) bool isLoading,
    @Default(false) bool isFirstLoadEnded,
    Object? exception,
  }) = _CreatedPillSheetValue;

  factory CreatedPillSheetValue.fromJson(Map<String, dynamic> json) =>
      _$CreatedPillSheetValueFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_CreatedPillSheetValueToJson(this as _$_CreatedPillSheetValue);
}
