import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/firestore_timestamp_converter.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';

part 'pill_sheet_modified_history.codegen.g.dart';
part 'pill_sheet_modified_history.codegen.freezed.dart';

class PillSheetModifiedHistoryFirestoreKeys {
  static const estimatedEventCausingDate = 'estimatedEventCausingDate';
  // TODO:  [PillSheetModifiedHistory-V2-BeforePillSheetGroupHistory] 2024-05-01
  // afterPillSheetGroup.idを用いて(null以外がセットされているので)フィルタリングできるようになるので、一つ前のピルシートグループの履歴を表示する機能を解放する
  // static const afterPillSheetGroupID = "afterPillSheetGroup.id";
  static const archivedDateTime = 'archivedDateTime';
}

enum PillSheetModifiedActionType {
  @JsonValue('createdPillSheet')
  createdPillSheet,
  @JsonValue('automaticallyRecordedLastTakenDate')
  automaticallyRecordedLastTakenDate,
  @JsonValue('deletedPillSheet')
  deletedPillSheet,
  @JsonValue('takenPill')
  takenPill,
  @JsonValue('revertTakenPill')
  revertTakenPill,
  @JsonValue('changedPillNumber')
  changedPillNumber,
  @JsonValue('endedPillSheet')
  endedPillSheet,
  @JsonValue('beganRestDuration')
  beganRestDuration,
  @JsonValue('endedRestDuration')
  endedRestDuration,
  @JsonValue('changedRestDurationBeginDate')
  changedRestDurationBeginDate,
  @JsonValue('changedRestDuration')
  changedRestDuration,
  @JsonValue('changedBeginDisplayNumber')
  changedBeginDisplayNumber,
  @JsonValue('changedEndDisplayNumber')
  changedEndDisplayNumber
}

extension PillSheetModifiedActionTypeFunctions on PillSheetModifiedActionType {
  String get name => toString().split('.').last;
}

// PillSheetModifiedHistory only create on backend
// If you want to make it from the client side, please match it with the property of backend
@freezed
class PillSheetModifiedHistory with _$PillSheetModifiedHistory {
  @JsonSerializable(explicitToJson: true)
  const factory PillSheetModifiedHistory({
    // Added since 2023-08-01
    @Default('v2') version,

    // ============ BEGIN: Added since v1 ============
    @JsonKey(includeIfNull: false) required String? id,
    required String actionType,
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
    // ============ END: Added since v1 ============

    // ============ BEGIN: Added since v2 ============
    // beforePillSheetGroup and afterPillSheetGroup is nullable
    // Because, actions for createdPillSheet and deletedPillSheet are not exists target single pill sheet
    required PillSheetGroup? beforePillSheetGroup,
    required PillSheetGroup? afterPillSheetGroup,
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? ttlExpiresDateTime,
    // TODO: [Archive-PillSheetModifiedHistory]: 2024-04以降に対応
    // 古いPillSheetModifiedHistoryのisArchivedにインデックスが貼られないため、TTLの期間内のデータが残っている間はこのフィールドが使えない
    // null含めて値を入れないとクエリの条件に合致しないので、2024-04まではarchivedDateTime,isArchivedのデータが必ず存在するPillSheetModifiedHistoryの準備機関とする
    // バッチを書いても良いが件数が多いのでこの方法をとっている
    @JsonKey(
      fromJson: TimestampConverter.timestampToDateTime,
      toJson: TimestampConverter.dateTimeToTimestamp,
    )
    DateTime? archivedDateTime,
    // archivedDateTime isNull: false の条件だと、下記のエラーの条件に引っ掛かるため、archivedDateTime以外にもisArchivedを用意している。isArchived == true | isArchived == false の用途で使う
    // You can combine constraints with a logical AND by chaining multiple equality operators (== or array-contains). However, you must create a composite index to combine equality operators with the inequality operators, <, <=, >, and !=.
    @Default(false) bool isArchived,
    // ============ END: Added since v2 ============

    required PillSheetModifiedHistoryValue value,
  }) = _PillSheetModifiedHistory;
  const PillSheetModifiedHistory._();

  factory PillSheetModifiedHistory.fromJson(Map<String, dynamic> json) => _$PillSheetModifiedHistoryFromJson(json);

  PillSheetModifiedActionType? get enumActionType => PillSheetModifiedActionType.values.firstWhereOrNull((element) => element.name == actionType);
}

// Factories
abstract class PillSheetModifiedHistoryServiceActionFactory {
  static const limitDays = 180;

  static PillSheetModifiedHistory _create({
    required PillSheetGroup? beforePillSheetGroup,
    required PillSheetGroup? afterPillSheetGroup,
    required PillSheetModifiedActionType actionType,
    required PillSheetModifiedHistoryValue value,
  }) {
    return PillSheetModifiedHistory(
      id: null,
      version: 'v2',
      actionType: actionType.name,
      value: value,
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
      estimatedEventCausingDate: now(),
      createdAt: now(),
      ttlExpiresDateTime: now().add(const Duration(days: limitDays)),
    );
  }

  static PillSheetModifiedHistory createTakenPillAction({
    required PillSheet before,
    required PillSheet after,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
    required bool isQuickRecord,
  }) {
    final afterLastTakenDate = after.lastTakenDate;
    if (afterLastTakenDate == null) {
      throw FormatException('unexpected lastTakenDate:${after.lastTakenDate} is null for takenPill action');
    }
    return _create(
      actionType: PillSheetModifiedActionType.takenPill,
      value: PillSheetModifiedHistoryValue(
        takenPill: TakenPillValue(
          afterLastTakenDate: afterLastTakenDate,
          afterLastTakenPillNumber: after.lastTakenOrZeroPillNumber,
          beforeLastTakenDate: before.lastTakenDate,
          beforeLastTakenPillNumber: before.lastTakenOrZeroPillNumber,
          isQuickRecord: isQuickRecord,
        ),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createRevertTakenPillAction({
    required PillSheet before,
    required PillSheet after,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    final beforeLastTakenDate = before.lastTakenDate;
    if (beforeLastTakenDate == null) {
      throw FormatException('unexpected before pill sheet lastTakenDate is null: ${before.lastTakenDate} for revertTakenPill action');
    }
    return _create(
      actionType: PillSheetModifiedActionType.revertTakenPill,
      value: PillSheetModifiedHistoryValue(
        revertTakenPill: RevertTakenPillValue(
          afterLastTakenDate: after.lastTakenDate,
          afterLastTakenPillNumber: after.lastTakenOrZeroPillNumber,
          beforeLastTakenDate: beforeLastTakenDate,
          beforeLastTakenPillNumber: before.lastTakenOrZeroPillNumber,
        ),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createCreatedPillSheetAction({
    required List<String> pillSheetIDs,
    required PillSheetGroup? beforePillSheetGroup,
    required PillSheetGroup createdNewPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.createdPillSheet,
      value: PillSheetModifiedHistoryValue(
        createdPillSheet: CreatedPillSheetValue(
          pillSheetCreatedAt: now(),
          pillSheetIDs: pillSheetIDs,
        ),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: createdNewPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createChangedPillNumberAction({
    required PillSheet before,
    required PillSheet after,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.changedPillNumber,
      value: PillSheetModifiedHistoryValue(
        changedPillNumber: ChangedPillNumberValue(
          afterBeginingDate: after.beginDate,
          beforeBeginingDate: before.beginDate,
          afterTodayPillNumber: after.todayPillNumber,
          beforeTodayPillNumber: before.todayPillNumber,
          beforeGroupIndex: before.groupIndex,
          afterGroupIndex: after.groupIndex,
        ),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createDeletedPillSheetAction({
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup updatedPillSheetGroup,
    required List<String> pillSheetIDs,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.deletedPillSheet,
      value: PillSheetModifiedHistoryValue(
        deletedPillSheet: DeletedPillSheetValue(
          pillSheetDeletedAt: now(),
          pillSheetIDs: pillSheetIDs,
        ),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: updatedPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createBeganRestDurationAction({
    required RestDuration restDuration,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.beganRestDuration,
      value: PillSheetModifiedHistoryValue(
        beganRestDurationValue: BeganRestDurationValue(
          restDuration: restDuration,
        ),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createEndedRestDurationAction({
    required RestDuration restDuration,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.endedRestDuration,
      value: PillSheetModifiedHistoryValue(
        endedRestDurationValue: EndedRestDurationValue(
          restDuration: restDuration,
        ),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createChangedRestDurationBeginDateAction({
    required RestDuration beforeRestDuration,
    required RestDuration afterRestDuration,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.changedRestDurationBeginDate,
      value: PillSheetModifiedHistoryValue(
        changedRestDurationBeginDateValue: ChangedRestDurationBeginDateValue(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
        ),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createChangedRestDurationAction({
    required RestDuration beforeRestDuration,
    required RestDuration afterRestDuration,
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.changedRestDuration,
      value: PillSheetModifiedHistoryValue(
        changedRestDurationValue: ChangedRestDurationValue(
          beforeRestDuration: beforeRestDuration,
          afterRestDuration: afterRestDuration,
        ),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createChangedBeginDisplayNumberAction({
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
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createChangedEndDisplayNumberAction({
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
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }
}

/// 渡されたPillSheetModifiedHistory配列から飲み忘れ日数を計算する
int missedPillDays({
  required List<PillSheetModifiedHistory> histories,
  required DateTime maxDate,
}) {
  if (histories.isEmpty) {
    return 0;
  }

  // 昇順に並べ替える。服用お休み期間の集計時に、服用お休みが開始された後の差分の日付を集計するために順番を整える必要がある
  final orderedHistories = histories.sortedBy((history) => history.estimatedEventCausingDate);

  final minDate = orderedHistories.map((history) => history.estimatedEventCausingDate).reduce((a, b) => a.isBefore(b) ? a : b);

  final allDates = <DateTime>{};
  final days = daysBetween(minDate, maxDate);
  for (var i = 0; i < days; i++) {
    allDates.add(minDate.add(Duration(days: i)));
  }

  // takenPill || automaticallyRecordedLastTakenDate アクションの日付を収集
  final takenDates = <DateTime>{};
  // beganRestDuration から endedRestDuration の間の日付を収集
  final restDurationDates = <DateTime>{};

  DateTime? historyBeginRestDurationDate;
  for (final history in orderedHistories) {
    // estimatedEventCausingDateの日付部分のみを使用
    final date = DateTime(
      history.estimatedEventCausingDate.year,
      history.estimatedEventCausingDate.month,
      history.estimatedEventCausingDate.day,
    );
    if (history.actionType == PillSheetModifiedActionType.takenPill.name ||
        history.actionType == PillSheetModifiedActionType.automaticallyRecordedLastTakenDate.name) {
      takenDates.add(date);
    }

    // 服用お休み中は記録されないので集計から除外
    // 先にhistoryBeginRestDurationDate != null チェックする必要がある。なぜなら、PillSheetModifiedActionType.beganRestDuration の時に値が入るから
    if (historyBeginRestDurationDate != null) {
      // PillSheetModifiedActionType.endedRestDuration.name であるか内科に関わらず計算に含めてしまう
      // 服用お休みが開始されて、次の履歴が服用お休み終了の場合は、服用お休みの日数を計算する
      // 服用お休みが開始されて、次の履歴が服用お休み以外の時は考慮パターンが多い。のでallDatesから除外するように計算に含めてしまう
      for (var i = 0; i < daysBetween(historyBeginRestDurationDate, date); i++) {
        restDurationDates.add(historyBeginRestDurationDate.add(Duration(days: i)));
      }
      historyBeginRestDurationDate = null;
    }

    if (history.actionType == PillSheetModifiedActionType.beganRestDuration.name) {
      historyBeginRestDurationDate = date;
    }
  }

  // 現在まで服用お休み中の場合には、差分の日付をrestDurationDatesに追加する
  if (historyBeginRestDurationDate != null) {
    for (var i = 0; i < daysBetween(historyBeginRestDurationDate, maxDate); i++) {
      restDurationDates.add(historyBeginRestDurationDate.add(Duration(days: i)));
    }
  }

  // 服用記録がない日数を計算
  final missedDays = allDates.difference(takenDates).difference(restDurationDates).length;
  return missedDays;
}
