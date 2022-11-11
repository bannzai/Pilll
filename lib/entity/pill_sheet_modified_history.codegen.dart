import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_document_id_escaping_to_json.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';

part 'pill_sheet_modified_history.codegen.g.dart';
part 'pill_sheet_modified_history.codegen.freezed.dart';

class PillSheetModifiedHistoryFirestoreKeys {
  static const estimatedEventCausingDate = "estimatedEventCausingDate";
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
  endedPillSheet,
  @JsonValue("beganRestDuration")
  beganRestDuration,
  @JsonValue("endedRestDuration")
  endedRestDuration,
  @JsonValue("changedBeginDisplayNumber")
  changedBeginDisplayNumber,
  @JsonValue("changedEndDisplayNumber")
  changedEndDisplayNumber
}

extension PillSheetModifiedActionTypeFunctions on PillSheetModifiedActionType {
  String get name => toString().split(".").last;
}

// PillSheetModifiedHistory only create on backend
// If you want to make it from the client side, please match it with the property of backend
@freezed
class PillSheetModifiedHistory with _$PillSheetModifiedHistory {
  @JsonSerializable(explicitToJson: true)
  const factory PillSheetModifiedHistory({
    @JsonKey(includeIfNull: false, toJson: toNull)
        required String? id,
    required String actionType,
    required PillSheetModifiedHistoryValue value,
    // This is deprecated property.
    // Instead of beforePillSheetID and afterPillSheetID
    required String? pillSheetID,
    // There are new properties for pill_sheet grouping. So it's all optional
    required String? pillSheetGroupID,
    required String? beforePillSheetID,
    required String? afterPillSheetID,
    // before and after is nullable
    // Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
    required PillSheet? before,
    required PillSheet? after,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime estimatedEventCausingDate,
    @JsonKey(
      fromJson: NonNullTimestampConverter.timestampToDateTime,
      toJson: NonNullTimestampConverter.dateTimeToTimestamp,
    )
        required DateTime createdAt,
  }) = _PillSheetModifiedHistory;
  const PillSheetModifiedHistory._();

  factory PillSheetModifiedHistory.fromJson(Map<String, dynamic> json) => _$PillSheetModifiedHistoryFromJson(json);

  PillSheetModifiedActionType? get enumActionType => PillSheetModifiedActionType.values.firstWhereOrNull((element) => element.name == actionType);
}
