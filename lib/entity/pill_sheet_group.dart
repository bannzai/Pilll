import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pill_sheet_group.g.dart';
part 'pill_sheet_group.freezed.dart';

abstract class PillSheetGroupFirestoreKeys {
  static final createdAt = "createdAt";
}

@freezed
abstract class PillSheetGroup implements _$PillSheetGroup {
  PillSheetGroup._();
  @JsonSerializable(explicitToJson: true)
  factory PillSheetGroup({
    required List<String> pillSheetIDs,
    required List<PillSheet> pillSheets,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? createdAt,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
        DateTime? deletedAt,
  }) = _PillSheetGroup;

  factory PillSheetGroup.fromJson(Map<String, dynamic> json) =>
      _$PillSheetGroupFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_PillSheetGroupToJson(this as _$_PillSheetGroup);
}
