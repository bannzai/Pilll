import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_document_id_escaping_to_json.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'menstruation.g.dart';
part 'menstruation.freezed.dart';

abstract class MenstruationFirestoreKey {
  static final String beginDate = "beginDate";
  static final String deletedAt = "deletedAt";
}

@freezed
abstract class Menstruation with _$Menstruation {
  String? get documentID => id;

  factory Menstruation.fromJson(Map<String, dynamic> json) =>
      _$MenstruationFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_MenstruationToJson(this as _$_Menstruation);
  Menstruation._();

  @JsonSerializable(explicitToJson: true)
  factory Menstruation({
    @JsonKey(includeIfNull: false, toJson: toNull)
        String? id,
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
