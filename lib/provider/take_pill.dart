import 'package:firebase_core/firebase_core.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/utils/alarm_kit_service.dart';
import 'package:pilll/utils/error_log.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final takePillProvider = Provider.autoDispose(
  (ref) => TakePill(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetModifiedHistory: ref.watch(
      batchSetPillSheetModifiedHistoryProvider,
    ),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
  ),
);

class TakePill {
  final BatchFactory batchFactory;

  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;

  TakePill({
    required this.batchFactory,
    required this.batchSetPillSheetModifiedHistory,
    required this.batchSetPillSheetGroup,
  });

  Future<PillSheetGroup?> call({
    required DateTime takenDate,
    required PillSheetGroup pillSheetGroup,
    required PillSheet activePillSheet,
    required bool isQuickRecord,
  }) async {
    // アラームは先に解除しちゃう。条件に関わらず。音が大きいので
    AlarmKitService.stopAllAlarms();

    // v1/v2で判定方法を分岐
    final isAlreadyTaken = switch (activePillSheet) {
      PillSheetV1() => activePillSheet.todayPillIsAlreadyTaken,
      PillSheetV2() => activePillSheet.todayPillAllTaken,
    };
    if (isAlreadyTaken) {
      return null;
    }

    final updatedPillSheets = pillSheetGroup.pillSheets.map((pillSheet) {
      // activePillSheetが服用可能な最後のピルシートなので、それよりも後ろのピルシートの場合はreturn
      if (pillSheet.groupIndex > activePillSheet.groupIndex) {
        return pillSheet;
      }
      // ピルシートが終了しているかどうかを判定
      final isEnded = switch (pillSheet) {
        PillSheetV1() =>
          pillSheet.typeInfo.totalCount == pillSheet.lastTakenOrZeroPillNumber,
        PillSheetV2() =>
          pillSheet.typeInfo.totalCount == pillSheet.lastCompletedPillNumber,
      };
      if (isEnded) {
        return pillSheet;
      }

      // takenDateよりも予測するピルシートの最終服用日よりも小さい場合は、そのピルシートの最終日で予測する最終服用日を記録する
      // 前のピルシートなので、最終ピルも含めて全てのピルを完了させる
      if (takenDate.isAfter(pillSheet.estimatedEndTakenDate)) {
        return pillSheet.takenPillSheet(
          pillSheet.estimatedEndTakenDate,
          completeAllPills: true,
        );
      }

      // takenDateがピルシートの開始日に満たない場合は、記録の対象になっていないので早期リターン
      // 一つ前のピルシートのピルをタップした時など
      if (takenDate.date().isBefore(pillSheet.beginDate.date())) {
        return pillSheet;
      }

      return pillSheet.takenPillSheet(takenDate);
    }).toList();

    final updatedPillSheetGroup = pillSheetGroup.copyWith(
      pillSheets: updatedPillSheets,
    );
    final updatedIndexses = pillSheetGroup.pillSheets.asMap().keys.where((
      index,
    ) {
      final updatedPillSheet = updatedPillSheetGroup.pillSheets[index];
      if (pillSheetGroup.pillSheets[index] == updatedPillSheet) {
        return false;
      }

      return true;
    }).toList();

    if (updatedIndexses.isEmpty) {
      // NOTE: prevent error for unit test
      if (Firebase.apps.isNotEmpty) {
        errorLogger.recordError(
          const FormatException('unexpected updatedIndexes is empty'),
          StackTrace.current,
        );
      }
      return null;
    }

    final batch = batchFactory.batch();
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);

    final history =
        PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
          isQuickRecord: isQuickRecord,
          beforePillSheetGroup: pillSheetGroup,
          afterPillSheetGroup: updatedPillSheetGroup,
        );
    batchSetPillSheetModifiedHistory(batch, history);

    await batch.commit();

    return updatedPillSheetGroup;
  }
}

/// PillSheetに服用記録を追加するためのextension
extension TakenPillSheet on PillSheet {
  /// 服用記録を追加したPillSheetを返す
  /// [completeAllPills] がtrueの場合、最後のピルも含めて全てのピルを完了させる
  /// 前のピルシートを処理する場合など、全てのピルを完了させる必要がある場合にtrueを指定する
  PillSheet takenPillSheet(
    DateTime takenDate, {
    bool completeAllPills = false,
  }) {
    return switch (this) {
      PillSheetV1 v1 => v1.copyWith(lastTakenDate: takenDate),
      PillSheetV2 v2 => v2._takenPillSheetV2(
        takenDate,
        completeAllPills: completeAllPills,
      ),
    };
  }
}

/// PillSheetV2専用のextension（内部実装用）
extension _TakenPillSheetV2 on PillSheetV2 {
  /// v2: pills を更新（lastTakenDateはpillsから導出されるため更新不要）
  /// takenDateまでの全てのピルに対して服用記録を追加する
  /// 途中に未完了のピルがあれば全て完了させ、最後のピルは1回の記録を追加する
  /// [completeAllPills] がtrueの場合、最後のピルも含めて全てのピルを完了させる
  PillSheet _takenPillSheetV2(
    DateTime takenDate, {
    bool completeAllPills = false,
  }) {
    // pillsが空の場合は何もせず元のシートを返す
    if (pills.isEmpty) {
      return this;
    }

    // 一番最後の記録対象のピル
    final rawFinalTakenPillIndex = pillNumberFor(targetDate: takenDate) - 1;
    // 範囲外のインデックスをクランプ
    final finalTakenPillIndex = rawFinalTakenPillIndex.clamp(
      0,
      pills.length - 1,
    );

    return copyWith(
      pills: pills.map((pill) {
        // takenDateから算出した記録されるピルのindexよりも大きい場合は何もしない
        if (pill.index > finalTakenPillIndex) {
          return pill;
        }
        if (pill.isCompleted) {
          return pill;
        }

        final pillTakenDoneList = [...pill.pillTakens];

        if (pill.index != finalTakenPillIndex || completeAllPills) {
          // NOTE: 一番最後の記録対象のピル以外は、ピルの服用記録をtakenCountに達するまで追加する
          // completeAllPillsがtrueの場合は、最後のピルも含めて全てのピルを完了させる
          for (var i = pill.pillTakens.length; i < pill.takenCount; i++) {
            pillTakenDoneList.add(
              PillTaken(
                recordedTakenDateTime: takenDate,
                createdDateTime: now(),
                updatedDateTime: now(),
              ),
            );
          }
        } else {
          // NOTE: 一番最後の記録対象のピルは、ピルの服用記録を1回追加する
          pillTakenDoneList.add(
            PillTaken(
              recordedTakenDateTime: takenDate,
              createdDateTime: now(),
              updatedDateTime: now(),
            ),
          );
        }
        return pill.copyWith(pillTakens: pillTakenDoneList);
      }).toList(),
    );
  }
}
