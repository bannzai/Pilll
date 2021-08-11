import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';

part 'pill_sheet_modified_history.g.dart';
part 'pill_sheet_modified_history.freezed.dart';

abstract class PillSheetModifiedHistoryFirestoreKeys {
  static final createdAt = "createdAt";
}

enum PillSheetModifiedActionType {
  @JsonValue("createdPillSheet")
  createdPillSheet,
  @JsonValue("automaticallyRecordedLastTakenDate")
  automaticallyRecordedLastTakenDate,
  @JsonValue("deletedPillSheet")
  deletedPillSheet,
  @JsonValue("takenPill")
  takenPill,
  @JsonValue("revertTakenPill")
  revertTakenPill,
  @JsonValue("changedPillNumber")
  changedPillNumber,
  @JsonValue("endedPillSheet")
  endedPillSheet
}

// PillSheetModifiedHistory only create on backend
// If you want to make it from the client side, please match it with the property of backend
@freezed
abstract class PillSheetModifiedHistory with _$PillSheetModifiedHistory {
  @JsonSerializable(explicitToJson: true)
  factory PillSheetModifiedHistory({
    required String actionType,
    required String userID,
    required PillSheetModifiedHistoryValue value,
    required PillSheet after,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime estimatedEventDateTime,
  }) = _PillSheetModifiedHistory;
  const PillSheetModifiedHistory._();

  factory PillSheetModifiedHistory.fromJson(Map<String, dynamic> json) =>
      _$PillSheetModifiedHistoryFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_PillSheetModifiedHistoryToJson(this as _$_PillSheetModifiedHistory);

  PillSheetModifiedActionType? get enumActionType =>
      PillSheetModifiedActionType.values.firstWhereOrNull(
          (element) => element.toString().split(".").last == actionType);
}
