import 'package:freezed_annotation/freezed_annotation.dart';

part 'today_pill_number_value.freezed.dart';

@freezed
class TodayPillNumberValue with _$TodayPillNumberValue {
  @JsonSerializable(explicitToJson: true)
  TodayPillNumberValue._();
  factory TodayPillNumberValue({
    required int pillNumberIntoPillSheet,
    required int sequentialPillNumber,
  }) = _TodayPillNumberValue;
}
