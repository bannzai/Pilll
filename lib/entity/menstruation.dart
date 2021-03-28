import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
part 'menstruation.g.dart';
part 'menstruation.freezed.dart';

@freezed
abstract class Menstruation with _$Menstruation {
  factory Menstruation.fromJson(Map<String, dynamic> json) =>
      _$MenstruationFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_MenstruationToJson(this as _$_Menstruation);
  @JsonSerializable(explicitToJson: true)
  factory Menstruation({
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime begin,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime end,
    required bool isPreview,
  }) = _Menstruation;
}
