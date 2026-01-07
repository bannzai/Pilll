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
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
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
      PillSheetV2() => activePillSheet.todayPillsAreAlreadyTaken,
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
        PillSheetV1() => pillSheet.typeInfo.totalCount == pillSheet.lastTakenOrZeroPillNumber,
        PillSheetV2() => pillSheet.typeInfo.totalCount == pillSheet.lastCompletedPillNumber,
      };
      if (isEnded) {
        return pillSheet;
      }

      // takenDateよりも予測するピルシートの最終服用日よりも小さい場合は、そのピルシートの最終日で予測する最終服用日を記録する
      if (takenDate.isAfter(pillSheet.estimatedEndTakenDate)) {
        return pillSheet.takenPillSheet(pillSheet.estimatedEndTakenDate);
      }

      // takenDateがピルシートの開始日に満たない場合は、記録の対象になっていないので早期リターン
      // 一つ前のピルシートのピルをタップした時など
      if (takenDate.date().isBefore(pillSheet.beginingDate.date())) {
        return pillSheet;
      }

      return pillSheet.takenPillSheet(takenDate);
    }).toList();

    final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
    final updatedIndexses = pillSheetGroup.pillSheets.asMap().keys.where((index) {
      final updatedPillSheet = updatedPillSheetGroup.pillSheets[index];
      if (pillSheetGroup.pillSheets[index] == updatedPillSheet) {
        return false;
      }

      return true;
    }).toList();

    if (updatedIndexses.isEmpty) {
      // NOTE: prevent error for unit test
      if (Firebase.apps.isNotEmpty) {
        errorLogger.recordError(const FormatException('unexpected updatedIndexes is empty'), StackTrace.current);
      }
      return null;
    }

    final batch = batchFactory.batch();
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);

    final before = pillSheetGroup.pillSheets[updatedIndexses.first];
    final after = updatedPillSheetGroup.pillSheets[updatedIndexses.last];
    final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
      pillSheetGroupID: pillSheetGroup.id,
      before: before,
      after: after,
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
  PillSheet takenPillSheet(DateTime takenDate) {
    switch (this) {
      case PillSheetV1():
        return _takenPillSheetV1(takenDate);
      case PillSheetV2():
        return _takenPillSheetV2(takenDate);
    }
  }

  /// v1: lastTakenDateのみを更新
  PillSheet _takenPillSheetV1(DateTime takenDate) {
    return copyWith(lastTakenDate: takenDate);
  }

  /// v2: pills と lastTakenDate を更新
  /// takenDateまでの全てのピルに対して服用記録を追加する
  /// 2錠飲みの場合は、最後のピル以外はpillTakenCount回の記録を追加し、
  /// 最後のピルは1回の記録を追加する
  PillSheet _takenPillSheetV2(DateTime takenDate) {
    final v2 = this as PillSheetV2;

    // 一番最後の記録対象のピル
    final finalTakenPillIndex = pillNumberFor(targetDate: takenDate) - 1;

    return v2.copyWith(
      lastTakenDate: takenDate,
      pills: v2.pills.map((pill) {
        // takenDateから算出した記録されるピルのindexよりも大きい場合は何もしない
        if (pill.index > finalTakenPillIndex) {
          return pill;
        }
        if (pill.pillTakens.length == v2.pillTakenCount) {
          return pill;
        }

        final pillTakenDoneList = [...pill.pillTakens];

        if (pill.index != finalTakenPillIndex) {
          // NOTE: 一番最後の記録対象のピル以外は、ピルの服用記録をv2.pillTakenCountに達するまで追加する
          for (var i = pill.pillTakens.length; i < v2.pillTakenCount; i++) {
            pillTakenDoneList.add(PillTaken(
              recordedTakenDateTime: takenDate,
              createdDateTime: now(),
              updatedDateTime: now(),
            ));
          }
        } else {
          // NOTE: 一番最後の記録対象のピルは、ピルの服用記録を1回追加する
          pillTakenDoneList.add(PillTaken(
            recordedTakenDateTime: takenDate,
            createdDateTime: now(),
            updatedDateTime: now(),
          ));
        }
        return pill.copyWith(pillTakens: pillTakenDoneList);
      }).toList(),
    );
  }
}
