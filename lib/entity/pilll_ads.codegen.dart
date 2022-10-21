import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';

part 'pilll_ads.codegen.freezed.dart';

@freezed
class PilllAds with _$PilllAds {
  factory PilllAds({
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime startDateTime,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime endDateTime,
    required String description,
    required String? imageURL,
    required String destinationURL,
  }) = _PilllAds;
  PilllAds._();
}
