import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_document_id_escaping_to_json.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';

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
    @JsonKey(includeIfNull: false, toJson: toNull) required String? id,
    required String actionType,
    required PillSheetModifiedHistoryValue value,
    // This is deprecated property. TODO: delete after 2024/01/01
    // Instead of beforePillSheetID and afterPillSheetID
    required String? pillSheetID,
    // This is deprecated property. TODO: delete after 2024/01/01
    // There are new properties for pill_sheet grouping. So it's all optional
    required String? pillSheetGroupID,
    required String? beforePillSheetID,
    required String? afterPillSheetID,
    // This is deprecated property. TODO: delete after 2024/01/01
    // Instead of beforePillSheetGroup and afterPillSheetGroup
    // before and after is nullable
    // Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
    required PillSheet? before,
    required PillSheet? after,
    // beforePillSheetGroup and afterPillSheetGroup is nullable
    // Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
    required PillSheetGroup? beforePillSheetGroup,
    required PillSheetGroup? afterPillSheetGroup,
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

// Factories
abstract class PillSheetModifiedHistoryServiceActionFactory {
  static PillSheetModifiedHistory _create({
    // Deprecated fields begin
    required PillSheet? before,
    required PillSheet? after,
    required String? pillSheetGroupID,
    required String? beforePillSheetID,
    required String? afterPillSheetID,
    // Deprecated fields end

    required PillSheetGroup? beforePillSheetGroup,
    required PillSheetGroup? afterPillSheetGroup,
    required PillSheetModifiedActionType actionType,
    required PillSheetModifiedHistoryValue value,
  }) {
    return PillSheetModifiedHistory(
      id: null,
      actionType: actionType.name,
      value: value,
      pillSheetID: null,
      pillSheetGroupID: pillSheetGroupID,
      afterPillSheetID: afterPillSheetID,
      beforePillSheetID: beforePillSheetID,
      before: before,
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
      after: after,
      estimatedEventCausingDate: now(),
      createdAt: now(),
    );
  }

  static PillSheetModifiedHistory createTakenPillAction({
    required String? pillSheetGroupID,
    required PillSheet before,
    required PillSheet after,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
    required bool isQuickRecord,
  }) {
    assert(pillSheetGroupID != null);

    final afterID = after.id;
    final afterLastTakenDate = after.lastTakenDate;
    if (afterID == null || afterLastTakenDate == null) {
      throw FormatException("unexpected afterPillSheetID: $afterID or lastTakenDate:${after.lastTakenDate} is null for takenPill action");
    }
    return _create(
      actionType: PillSheetModifiedActionType.takenPill,
      value: PillSheetModifiedHistoryValue(
        takenPill: TakenPillValue(
          afterLastTakenDate: afterLastTakenDate,
          afterLastTakenPillNumber: after.lastTakenPillNumber,
          beforeLastTakenDate: before.lastTakenDate,
          beforeLastTakenPillNumber: before.lastTakenPillNumber,
          isQuickRecord: isQuickRecord,
        ),
      ),
      after: after,
      beforePillSheetID: before.id,
      afterPillSheetID: afterID,
      pillSheetGroupID: pillSheetGroupID,
      before: before,
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createRevertTakenPillAction({
    required String? pillSheetGroupID,
    required PillSheet before,
    required PillSheet after,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    assert(pillSheetGroupID != null);

    final afterID = after.id;
    final afterLastTakenDate = after.lastTakenDate;
    if (afterID == null || afterLastTakenDate == null) {
      throw FormatException("unexpected afterPillSheetID: $afterID or lastTakenDate:${after.lastTakenDate} is null for revertTakenPill action");
    }
    final beforeID = before.id;
    final beforeLastTakenDate = before.lastTakenDate;
    if (beforeID == null || beforeLastTakenDate == null) {
      throw FormatException(
          "unexpected before pill sheet id or lastTakenDate is null id: ${before.id}, lastTakenDate: ${before.lastTakenDate} for revertTakenPill action");
    }
    return _create(
      actionType: PillSheetModifiedActionType.revertTakenPill,
      value: PillSheetModifiedHistoryValue(
        revertTakenPill: RevertTakenPillValue(
          afterLastTakenDate: afterLastTakenDate,
          afterLastTakenPillNumber: after.lastTakenPillNumber,
          beforeLastTakenDate: beforeLastTakenDate,
          beforeLastTakenPillNumber: before.lastTakenPillNumber,
        ),
      ),
      after: after,
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: beforeID,
      afterPillSheetID: afterID,
      before: before,
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createCreatedPillSheetAction({
    required String? pillSheetGroupID,
    required List<String> pillSheetIDs,
    required PillSheetGroup? beforePillSheetGroup,
    required PillSheetGroup createdNewPillSheetGroup,
  }) {
    assert(pillSheetGroupID != null);

    return _create(
      actionType: PillSheetModifiedActionType.createdPillSheet,
      value: PillSheetModifiedHistoryValue(
        createdPillSheet: CreatedPillSheetValue(
          pillSheetCreatedAt: now(),
          pillSheetIDs: pillSheetIDs,
        ),
      ),
      pillSheetGroupID: pillSheetGroupID,
      before: null,
      beforePillSheetID: null,
      after: null,
      afterPillSheetID: null,
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: createdNewPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createChangedPillNumberAction({
    required String? pillSheetGroupID,
    required PillSheet before,
    required PillSheet after,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    assert(pillSheetGroupID != null);

    final afterID = after.id;
    if (afterID == null || pillSheetGroupID == null) {
      throw FormatException("unexpected pillSheetGroupID: $pillSheetGroupID, or afterPillSheetID: $afterID  is null for changePillNumber action");
    }

    return _create(
      actionType: PillSheetModifiedActionType.changedPillNumber,
      value: PillSheetModifiedHistoryValue(
        changedPillNumber: ChangedPillNumberValue(
          afterBeginingDate: after.beginingDate,
          beforeBeginingDate: before.beginingDate,
          afterTodayPillNumber: after.todayPillNumber,
          beforeTodayPillNumber: before.todayPillNumber,
          beforeGroupIndex: before.groupIndex,
          afterGroupIndex: after.groupIndex,
        ),
      ),
      after: after,
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: before.id,
      afterPillSheetID: afterID,
      before: before,
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createDeletedPillSheetAction({
    required PillSheetGroup pillSheetGroup,
    required String? pillSheetGroupID,
    required List<String> pillSheetIDs,
  }) {
    assert(pillSheetGroupID != null);

    return _create(
      actionType: PillSheetModifiedActionType.deletedPillSheet,
      value: PillSheetModifiedHistoryValue(
        deletedPillSheet: DeletedPillSheetValue(
          pillSheetDeletedAt: now(),
          pillSheetIDs: pillSheetIDs,
        ),
      ),
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: null,
      afterPillSheetID: null,
      before: null,
      after: null,
      beforePillSheetGroup: pillSheetGroup,
      afterPillSheetGroup: null,
    );
  }

  static PillSheetModifiedHistory createBeganRestDurationAction({
    required String? pillSheetGroupID,
    required PillSheet before,
    required PillSheet after,
    required RestDuration restDuration,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    assert(pillSheetGroupID != null);

    return _create(
      actionType: PillSheetModifiedActionType.beganRestDuration,
      value: PillSheetModifiedHistoryValue(
        beganRestDurationValue: BeganRestDurationValue(
          restDuration: restDuration,
        ),
      ),
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: before.id,
      afterPillSheetID: after.id,
      before: before,
      after: after,
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createEndedRestDurationAction({
    required String? pillSheetGroupID,
    required PillSheet before,
    required PillSheet after,
    required RestDuration restDuration,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    assert(pillSheetGroupID != null);

    return _create(
      actionType: PillSheetModifiedActionType.endedRestDuration,
      value: PillSheetModifiedHistoryValue(
        endedRestDurationValue: EndedRestDurationValue(
          restDuration: restDuration,
        ),
      ),
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: before.id,
      afterPillSheetID: after.id,
      before: before,
      after: after,
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createChangedBeginDisplayNumberAction({
    required String? pillSheetGroupID,
    required PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting,
    required PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.changedBeginDisplayNumber,
      value: PillSheetModifiedHistoryValue(
        changedBeginDisplayNumber: ChangedBeginDisplayNumberValue(
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
        ),
      ),
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: null,
      afterPillSheetID: null,
      before: null,
      after: null,
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createChangedEndDisplayNumberAction({
    required String? pillSheetGroupID,
    required PillSheetGroupDisplayNumberSetting? beforeDisplayNumberSetting,
    required PillSheetGroupDisplayNumberSetting afterDisplayNumberSetting,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.changedEndDisplayNumber,
      value: PillSheetModifiedHistoryValue(
        changedEndDisplayNumber: ChangedEndDisplayNumberValue(
          beforeDisplayNumberSetting: beforeDisplayNumberSetting,
          afterDisplayNumberSetting: afterDisplayNumberSetting,
        ),
      ),
      pillSheetGroupID: pillSheetGroupID,
      beforePillSheetID: null,
      afterPillSheetID: null,
      before: null,
      after: null,
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }
}
