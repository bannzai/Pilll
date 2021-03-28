import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
part 'menstruation.g.dart';
part 'menstruation.freezed.dart';

abstract class MenstruationFirestoreKey {
  static final String beginDate = "beginDate";
  static final String deletedAt = "deletedAt";
}

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
        required DateTime beginDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime endDate,
    required bool isPreview,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? deletedAt,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime createdAt,
  }) = _Menstruation;
}
