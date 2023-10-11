import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pill_sheet_modified_history.g.dart';

@Riverpod(dependencies: [database, database])
Stream<List<PillSheetModifiedHistory>> pillSheetModifiedHistories(PillSheetModifiedHistoriesRef ref, {DateTime? afterCursor}) {
  if (afterCursor != null) {
    return ref
        .watch(databaseProvider)
        .pillSheetModifiedHistoriesReference()
        .where(
          PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate,
          isLessThanOrEqualTo: today().add(const Duration(days: 1)),
          isGreaterThanOrEqualTo: today().subtract(const Duration(days: PillSheetModifiedHistoryServiceActionFactory.limitDays)),
        )
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
        .startAfter([afterCursor])
        .limit(20)
        .snapshots()
        .map((reference) => reference.docs)
        .map((docs) => docs.map((doc) => doc.data()).toList());
  } else {
    return ref
        .watch(databaseProvider)
        .pillSheetModifiedHistoriesReference()
        .where(
          PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate,
          isLessThanOrEqualTo: today().add(const Duration(days: 1)),
          isGreaterThanOrEqualTo: today().subtract(const Duration(days: PillSheetModifiedHistoryServiceActionFactory.limitDays)),
        )
        .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
        .limit(20)
        .snapshots()
        .map((reference) => reference.docs)
        .map((docs) => docs.map((doc) => doc.data()).toList());
  }
}

@Riverpod(dependencies: [database])
Stream<List<PillSheetModifiedHistory>> pillSheetModifiedHistoriesWithLimit(PillSheetModifiedHistoriesWithLimitRef ref, {required int limit}) {
  return ref
      .watch(databaseProvider)
      .pillSheetModifiedHistoriesReference()
      .where(
        PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate,
        isLessThanOrEqualTo: today().add(const Duration(days: 1)),
        isGreaterThanOrEqualTo: today().subtract(const Duration(days: PillSheetModifiedHistoryServiceActionFactory.limitDays)),
      )
      .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
      .limit(limit)
      .snapshots()
      .map((reference) => reference.docs)
      .map((docs) => docs.map((doc) => doc.data()).toList());
}

// 頻繁に切り替わることも予想されるので、keepAliveをtrueにしている
@Riverpod(keepAlive: true, dependencies: [database])
Stream<List<PillSheetModifiedHistory>> pillSheetModifiedHistoriesWithRange(
  PillSheetModifiedHistoriesWithRangeRef ref, {
  required DateTime begin,
  required DateTime end,
}) {
  // PillSheetGroupのidをDBに保存していなかったので、PillSheetModifiedHistory.afterPillSheetGroup.id指定でのDBからの取得ができなかった(入れ子になっている構造体のIDで取得できる可動かは要確認が必要。未確認)
  // この時の問題点が続けてdeleteしたPillSheetGroupがあると日付がPillSheetModifiedHistoryを取得する際の日付指定が被ってしまい関係のないピルシートグループの履歴まで取得できてしまう点にある
  // なので、致し方なくdeletedAt is nullの条件を追加して連続で削除しても履歴取得の際には日付が被らないようにしている。
  // TODO: [PillSheetModifiedHistory-V2] 2024-05-01 ここでの取得をPillSheetModifiedHistory.afterPillSheetGroup.id指定でのDBからの取得に変更する
  // PillSheetGroupのidをDBに保存していなかったので、PillSheetModifiedHistory.afterPillSheetGroup.id指定でのDBからの取得ができなかった(入れ子になっている構造体のIDで取得できる可動かは要確認が必要。未確認)
  return ref
      .watch(databaseProvider)
      .pillSheetModifiedHistoriesReference()
      .where(
        PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate,
        isLessThanOrEqualTo: end.endOfDay(),
        isGreaterThanOrEqualTo: begin.date(),
      )
      .orderBy(PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate, descending: true)
      .snapshots()
      .map((reference) => reference.docs)
      .map((docs) => docs.map((doc) => doc.data()).toList());
}

final batchSetPillSheetModifiedHistoryProvider = Provider((ref) => BatchSetPillSheetModifiedHistory(ref.watch(databaseProvider)));

class BatchSetPillSheetModifiedHistory {
  final DatabaseConnection databaseConnection;
  BatchSetPillSheetModifiedHistory(this.databaseConnection);

  void call(WriteBatch batch, PillSheetModifiedHistory history) async {
    batch.set(databaseConnection.pillSheetModifiedHistoryReference(pillSheetModifiedHistoryID: null), history, SetOptions(merge: true));
  }
}

final setPillSheetModifiedHistoryProvider = Provider((ref) => SetPillSheetModifiedHistory(ref.watch(databaseProvider)));

class SetPillSheetModifiedHistory {
  final DatabaseConnection databaseConnection;
  SetPillSheetModifiedHistory(this.databaseConnection);

  Future<void> call(PillSheetModifiedHistory history) async {
    await databaseConnection.pillSheetModifiedHistoryReference(pillSheetModifiedHistoryID: history.id).set(history, SetOptions(merge: true));
  }
}
