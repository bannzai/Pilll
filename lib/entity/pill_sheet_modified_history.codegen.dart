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
  changedEndDisplayNumber,
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
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
    required bool isQuickRecord,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.takenPill,
      value: PillSheetModifiedHistoryValue(
        takenPill: TakenPillValue(isQuickRecord: isQuickRecord),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createRevertTakenPillAction({
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.revertTakenPill,
      value: PillSheetModifiedHistoryValue(
        revertTakenPill: RevertTakenPillValue(),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createCreatedPillSheetAction({
    required PillSheetGroup? beforePillSheetGroup,
    required PillSheetGroup createdNewPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.createdPillSheet,
      value: PillSheetModifiedHistoryValue(
        createdPillSheet: CreatedPillSheetValue(),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: createdNewPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createChangedPillNumberAction({
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.changedPillNumber,
      value: PillSheetModifiedHistoryValue(
        changedPillNumber: ChangedPillNumberValue(),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createDeletedPillSheetAction({
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup updatedPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.deletedPillSheet,
      value: PillSheetModifiedHistoryValue(
        deletedPillSheet: DeletedPillSheetValue(),
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
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.changedBeginDisplayNumber,
      value: PillSheetModifiedHistoryValue(
        changedBeginDisplayNumber: ChangedBeginDisplayNumberValue(),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }

  static PillSheetModifiedHistory createChangedEndDisplayNumberAction({
    required PillSheetGroup beforePillSheetGroup,
    required PillSheetGroup afterPillSheetGroup,
  }) {
    return _create(
      actionType: PillSheetModifiedActionType.changedEndDisplayNumber,
      value: PillSheetModifiedHistoryValue(
        changedEndDisplayNumber: ChangedEndDisplayNumberValue(),
      ),
      beforePillSheetGroup: beforePillSheetGroup,
      afterPillSheetGroup: afterPillSheetGroup,
    );
  }
}

/// 渡されたPillSheetModifiedHistory配列から、服用予定日（集計期間の全日 − 服用お休み日）と
/// 服用記録のあった日の集合を構築する。集計対象が無い場合は null を返す。
/// 日付はすべて日付のみ（午前0時）に正規化して集合化する。時刻付きのまま差分すると服用日が一致せず記録が漏れるため。
/// [beginDate] を渡すと集計開始日として使い（シート開始日など）、省略時は最古の履歴日を開始日とする。
({Set<DateTime> scheduledDates, Set<DateTime> takenDates})? pillTakenDateSets({
  required List<PillSheetModifiedHistory> histories,
  required DateTime maxDate,
  DateTime? beginDate,
}) {
  // 昇順に並べ替える。服用お休み期間の集計時に、服用お休みが開始された後の差分の日付を集計するために順番を整える必要がある
  final orderedHistories = histories.sortedBy(
    (history) => history.estimatedEventCausingDate,
  );

  // 集計開始日: beginDate 指定があればそれを、なければ最古の履歴日を使う。時刻を持つと日付集合の差分がずれるため日付のみに正規化する
  final DateTime minDate;
  if (beginDate != null) {
    minDate = beginDate.date();
  } else {
    if (orderedHistories.isEmpty) {
      return null;
    }
    minDate = orderedHistories.first.estimatedEventCausingDate.date();
  }
  final normalizedMaxDate = maxDate.date();

  final allDates = <DateTime>{};
  final days = daysBetween(minDate, normalizedMaxDate);
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
    final date = history.estimatedEventCausingDate.date();
    if (history.actionType == PillSheetModifiedActionType.takenPill.name ||
        history.actionType == PillSheetModifiedActionType.automaticallyRecordedLastTakenDate.name) {
      takenDates.add(date);
    }

    // 服用記録の取り消しを反映する。取り消された日 = (取り消し後の最終服用日, 取り消し前の最終服用日] の範囲。
    // 時系列順に処理しているため、取り消し後に再記録された日は後続の takenPill で再度追加される
    if (history.actionType == PillSheetModifiedActionType.revertTakenPill.name) {
      final beforeLastTakenDate = history.beforePillSheetGroup?.lastTakenPillSheetOrFirstPillSheet.lastTakenDate;
      if (beforeLastTakenDate != null) {
        final afterLastTakenDate = history.afterPillSheetGroup?.lastTakenPillSheetOrFirstPillSheet.lastTakenDate;
        takenDates.removeWhere(
          (takenDate) =>
              (afterLastTakenDate == null || takenDate.isAfter(afterLastTakenDate.date())) && !takenDate.isAfter(beforeLastTakenDate.date()),
        );
      }
    }

    // 服用お休み中は記録されないので集計から除外
    // 先にhistoryBeginRestDurationDate != null チェックする必要がある。なぜなら、PillSheetModifiedActionType.beganRestDuration の時に値が入るから
    if (historyBeginRestDurationDate != null) {
      // PillSheetModifiedActionType.endedRestDuration.name であるか内科に関わらず計算に含めてしまう
      // 服用お休みが開始されて、次の履歴が服用お休み終了の場合は、服用お休みの日数を計算する
      // 服用お休みが開始されて、次の履歴が服用お休み以外の時は考慮パターンが多い。のでallDatesから除外するように計算に含めてしまう
      for (var i = 0; i < daysBetween(historyBeginRestDurationDate, date); i++) {
        restDurationDates.add(
          historyBeginRestDurationDate.add(Duration(days: i)),
        );
      }
      historyBeginRestDurationDate = null;
    }

    if (history.actionType == PillSheetModifiedActionType.beganRestDuration.name) {
      historyBeginRestDurationDate = date;
    }
  }

  // 現在まで服用お休み中の場合には、差分の日付をrestDurationDatesに追加する
  if (historyBeginRestDurationDate != null) {
    for (var i = 0; i < daysBetween(historyBeginRestDurationDate, normalizedMaxDate); i++) {
      restDurationDates.add(
        historyBeginRestDurationDate.add(Duration(days: i)),
      );
    }
  }

  return (scheduledDates: allDates.difference(restDurationDates), takenDates: takenDates);
}

/// 渡されたPillSheetModifiedHistory配列から飲み忘れ日数を計算する
int missedPillDays({
  required List<PillSheetModifiedHistory> histories,
  required DateTime maxDate,
}) {
  final sets = pillTakenDateSets(histories: histories, maxDate: maxDate);
  if (sets == null) {
    return 0;
  }
  // 服用予定日のうち服用記録がない日数を計算
  return sets.scheduledDates.difference(sets.takenDates).length;
}
