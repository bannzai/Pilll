import 'dart:math';

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

    if (activePillSheet.todayPillsAreAlreadyTaken) {
      return null;
    }

    final updatedPillSheets = pillSheetGroup.pillSheets.map((pillSheet) {
      // activePillSheetが服用可能な最後のピルシートなので、それよりも後ろのピルシートの場合はreturn
      if (pillSheet.groupIndex > activePillSheet.groupIndex) {
        return pillSheet;
      }
      if (pillSheet.isEnded) {
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
  /// takenDateまでの全てのピルに対して服用記録を追加する
  /// 2錠飲みの場合は、最後のピル以外はpillTakenCount回の記録を追加し、
  /// 最後のピルは1回の記録を追加する
  PillSheet takenPillSheet(DateTime takenDate) {
    // 一番最後の記録対象のピル。takenDateが今日の日付(クイックレコードや「飲んだ」を押した時)の場合は、takenDateは今日の日付になる。その場合はtodayPillIndexと等価の値になる
    // max(estimatedLastTakenPillIndex, finalTakenPillIndex)としないのは、下のpill.index > finalTakenPillIndexで早期リターンされるので書いていない。estimatedLastTakenPillIndex を新しく用意するほどでも無いと思ったので
    final finalTakenPillIndex = pillNumberFor(targetDate: takenDate) - 1;

    return copyWith(
      lastTakenDate: takenDate,
      pills: pills.map((pill) {
        // takenDateから算出した記録されるピルのindexよりも大きい場合は何もしない
        // ユーザーがピルをタップした時等にtakenDateは今日以外の日付が入ってくる
        // pill.index > todayPillIndexの役割も理論的には備えているので、この条件文だけで良い
        if (pill.index > finalTakenPillIndex) {
          return pill;
        }
        if (pill.pillTakens.length == pillTakenCount) {
          return pill;
        }

        final pillTakenDoneList = [...pill.pillTakens];

        if (pill.index != finalTakenPillIndex) {
          // NOTE: 一番最後の記録対象のピル以外は、ピルの服用記録をpillTakenCountに達するまで追加する
          for (var i = max(0, pill.pillTakens.length - 1); i < pillTakenCount; i++) {
            pillTakenDoneList.add(PillTaken(
              recordedTakenDateTime: takenDate,
              createdDateTime: now(),
              updatedDateTime: now(),
            ));
          }
        } else {
          // pill == estimatedTakenPillIndex
          // NOTE: 一番最後の記録対象のピルは、ピルの服用記録を追加する。
          // 2回服用の場合で未服用の場合は残りの服用回数は1回になる。1回服用済みの場合は2回になる
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
