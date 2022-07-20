import 'package:flutter/material.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/database/pill_sheet.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/util/datetime/date_compare.dart';

class TakePill {
  final BatchFactory batchFactory;
  final PillSheetDatastore pillSheetDatastore;
  final PillSheetModifiedHistoryDatastore pillSheetModifiedHistoryDatastore;
  final PillSheetGroupDatastore pillSheetGroupDatastore;

  TakePill({
    required this.batchFactory,
    required this.pillSheetDatastore,
    required this.pillSheetModifiedHistoryDatastore,
    required this.pillSheetGroupDatastore,
  });

  Future<PillSheetGroup?> call({
    required DateTime takenDate,
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
    required bool isQuickRecord,
  }) async {
    if (activedPillSheet.todayPillIsAlreadyTaken) {
      return null;
    }

    final updatedPillSheets = pillSheetGroup.pillSheets.map((pillSheet) {
      if (pillSheet.groupIndex > activedPillSheet.groupIndex) {
        return pillSheet;
      }
      if (pillSheet.isEnded) {
        return pillSheet;
      }

      // takenDateよりも予測するピルシートの最終服用日よりも大きい場合はactivedPillSheetじゃないPillSheetと判断。
      // そのピルシートの最終日で予測する最終服用日を記録する
      if (takenDate.isAfter(pillSheet.estimatedEndTakenDate)) {
        debugPrint("$takenDate, $pillSheet, ${pillSheet.estimatedEndTakenDate}");
        return pillSheet.copyWith(lastTakenDate: pillSheet.estimatedEndTakenDate);
      } else {
        return pillSheet.copyWith(lastTakenDate: takenDate);
      }
    }).toList();
    debugPrint("$updatedPillSheets");

    final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
    final updatedIndexses = pillSheetGroup.pillSheets.asMap().keys.where((index) {
      final updatedPillSheet = updatedPillSheetGroup.pillSheets[index];
      if (pillSheetGroup.pillSheets[index] == updatedPillSheet) {
        return false;
      }

      // TODO: テストコード書いて不要だった場合消す
      // 例えば2枚目のピルシート(groupIndex:1)がアクティブで、1枚目のピルシート(groupIndex:0)の最終日を記録した場合(28番目)、2枚目のピルシートのlastTakenDateが1枚目の28番目のピルシートのlastTakenDateと同じになる。
      // その場合後続の処理で決定する履歴のafter: PillSheetの値が2枚目のピルシートの値になってしまう。これを避けるための条件式になっている
      if (updatedPillSheet.groupIndex == activedPillSheet.groupIndex) {
        debugPrint("1");
        if (index > 0) {
          debugPrint("2");
          final previousUpdatedPillSheet = updatedPillSheetGroup.pillSheets[index - 1];
          final previousUpdatedPillSheetLastTakenDate = previousUpdatedPillSheet.lastTakenDate;
          assert(previousUpdatedPillSheetLastTakenDate != null, "事前処理でnullではないはず。previousUpdatedPillSheetLastTakenDate != null");
          if (previousUpdatedPillSheetLastTakenDate != null) {
            debugPrint("3");
            if (isSameDay(previousUpdatedPillSheetLastTakenDate, takenDate)) {
              debugPrint("4");
              final updatedPillSheetLastTakenDate = updatedPillSheet.lastTakenDate;
              assert(updatedPillSheetLastTakenDate != null, "事前処理でnullではないはず。updatedPillSheetLastTakenDate != null");
              if (updatedPillSheetLastTakenDate != null) {
                debugPrint("5");
                if (isSameDay(previousUpdatedPillSheetLastTakenDate, updatedPillSheetLastTakenDate)) {
                  debugPrint("6");
                  return false;
                }
              }
            }
          }
        }
      }

      return true;
    }).toList();

    debugPrint("updatedIndexses: $updatedIndexses");
    if (updatedIndexses.isEmpty) {
      errorLogger.recordError(const FormatException("unexpected updatedIndexes is empty"), StackTrace.current);
      return null;
    }

    final batch = batchFactory.batch();
    pillSheetDatastore.update(
      batch,
      updatedPillSheets,
    );
    pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup);

    final before = pillSheetGroup.pillSheets[updatedIndexses.first];
    final after = updatedPillSheetGroup.pillSheets[updatedIndexses.last];
    debugPrint("before: $before, after: $after");
    final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
      pillSheetGroupID: pillSheetGroup.id,
      before: before,
      after: after,
      isQuickRecord: isQuickRecord,
    );
    pillSheetModifiedHistoryDatastore.add(batch, history);

    await batch.commit();

    return updatedPillSheetGroup;
  }
}
