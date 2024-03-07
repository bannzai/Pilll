import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/reminder_notification_customization.codegen.dart';

part 'user_pill_sheet_type.codegen.g.dart';
part 'user_pill_sheet_type.codegen.freezed.dart';

@freezed
class UserPillSheetType with _$UserPillSheetType {
  @JsonSerializable(explicitToJson: true)
  const factory UserPillSheetType({
    required String name,
    required int totalCount,
    required int dosingPeriod,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
    required DateTime createdDateTime,
  }) = _UserPillSheetType;
  const UserPillSheetType._();

  factory UserPillSheetType.fromJson(Map<String, dynamic> json) => _$UserPillSheetTypeFromJson(json);
}
