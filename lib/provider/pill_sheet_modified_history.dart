import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pill_sheet_modified_history.g.dart';

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
  // TODO:  [PillSheetModifiedHistory-V2-BeforePillSheetGroupHistory] 2024-05-01
  // ピルシートグループIDを用いてフィルタリングできるようになるので、一つ前のピルシートグループの履歴を表示する機能を解放する
  // PillSheetModifiedHistoryFirestoreKeys.afterPillSheetGroupID を使用してDBから取得する
  // PillSheetModifiedHistoryFirestoreKeys.estimatedEventCausingDate での並び替えはインデックスを貼るのは面倒なのでインメモリでsortすれば良いと考えている
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

// 過去30日間で服用記録がない日数をカウントするProvider
@riverpod
Future<int> missedPillDaysInLast30Days(MissedPillDaysInLast30DaysRef ref) async {
  debugPrint('[missedPillDaysInLast30Days] Provider called at ${DateTime.now()}');

  // 日付を固定して、同じ日の間は同じ値を返すようにする
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final thirtyDaysAgo = todayStart.subtract(const Duration(days: 30));

  debugPrint('[missedPillDaysInLast30Days] Watching pillSheetModifiedHistoriesWithRange from $thirtyDaysAgo to $todayStart');

  // Streamの最初の値を待つ
  final histories = await ref.watch(
    pillSheetModifiedHistoriesWithRangeProvider(
      begin: thirtyDaysAgo,
      end: todayStart,
    ).future,
  );

  debugPrint('[missedPillDaysInLast30Days] Histories count: ${histories.length}');

  if (histories.isEmpty) {
    debugPrint('[missedPillDaysInLast30Days] No histories found, returning 0');
    return 0;
  }

  final minDate = histories.map((history) => history.estimatedEventCausingDate).reduce((a, b) => a.isBefore(b) ? a : b);
  final maxDate = histories.map((history) => history.estimatedEventCausingDate).reduce((a, b) => a.isAfter(b) ? a : b);

  final allDates = <DateTime>{};
  final days = daysBetween(minDate, maxDate);
  for (var i = 0; i < days; i++) {
    allDates.add(minDate.add(Duration(days: i)));
  }

  // takenPill || automaticallyRecordedLastTakenDate アクションの日付を収集
  final takenDates = <DateTime>{};
  // beganRestDuration から endedRestDuration の間の日付を収集
  final restDurationDates = <DateTime>{};

  var isRestDuration = false;
  for (final history in histories) {
    if (history.actionType == PillSheetModifiedActionType.takenPill.name ||
        history.actionType == PillSheetModifiedActionType.automaticallyRecordedLastTakenDate.name) {
      // estimatedEventCausingDateの日付部分のみを使用
      final date = DateTime(
        history.estimatedEventCausingDate.year,
        history.estimatedEventCausingDate.month,
        history.estimatedEventCausingDate.day,
      );
      takenDates.add(date);
    }

    if (history.actionType == PillSheetModifiedActionType.beganRestDuration.name) {
      isRestDuration = true;
      restDurationDates.add(history.estimatedEventCausingDate);
    }
    if (isRestDuration) {
      restDurationDates.add(history.estimatedEventCausingDate);
    }
    if (history.actionType == PillSheetModifiedActionType.endedRestDuration.name) {
      isRestDuration = false;
    }
  }

  // 服用記録がない日数を計算
  final missedDays = allDates.difference(takenDates).length;
  debugPrint('[missedPillDaysInLast30Days] Calculated missed days: $missedDays');
  return missedDays;
}
