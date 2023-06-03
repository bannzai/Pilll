import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

part 'pill.codegen.g.dart';
part 'pill.codegen.freezed.dart';

class PillFirestoreKey {
  static const String typeInfo = "typeInfo";
  static const String createdAt = "createdAt";
  static const String deletedAt = "deletedAt";
  static const String lastPillTakenDate = "lastPillTakenDate";
  static const String beginingDate = "beginingDate";
}

@freezed
class PillTaken with _$PillTaken {
  @JsonSerializable(explicitToJson: true)
  const factory PillTaken({
    // 同時服用を行った場合は対象となるPillTakenのtakenDateTimeは同一にする
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime takenDateTime,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    required DateTime? revertedDateTime,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime createdDateTime,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime updatedDateTime,
    // backendで自動的に記録された場合にtrue
    @Default(false) bool isAutomaticallyRecorded,
  }) = _PillTaken;

  factory PillTaken.fromJson(Map<String, dynamic> json) => _$PillTakenFromJson(json);
}

@freezed
class Pill with _$Pill {
  const Pill._();
  @JsonSerializable(explicitToJson: true)
  const factory Pill(
      {required int index,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      required DateTime createdDateTime,
      @JsonKey(
        fromJson: NonNullTimestampConverter.timestampToDateTime,
        toJson: NonNullTimestampConverter.dateTimeToTimestamp,
      )
      required DateTime updatedDateTime,
      required List<PillTaken> pillTakens}) = _Pill;

  factory Pill.fromJson(Map<String, dynamic> json) => _$PillFromJson(json);

  static List<Pill> generate(PillSheetType pillSheetType) {
    return List.generate(
      pillSheetType.totalCount,
      (index) => Pill(
        index: index,
        createdDateTime: DateTime.now(),
        updatedDateTime: DateTime.now(),
        pillTakens: [],
      ),
    );
  }
}
