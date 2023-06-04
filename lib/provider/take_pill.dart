import 'package:firebase_core/firebase_core.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/utils/error_log.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final takePillProvider = Provider(
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
    required PillSheet activedPillSheet,
    required bool isQuickRecord,
  }) async {
    if (activedPillSheet.todayPillsAreAlreadyTaken) {
      return null;
    }

    final updatedPillSheets = pillSheetGroup.pillSheets.map((pillSheet) {
      if (pillSheet.groupIndex > activedPillSheet.groupIndex) {
        return pillSheet;
      }
      if (pillSheet.isEnded) {
        return pillSheet;
      }

      // takenDateよりも予測するピルシートの最終服用日よりも小さい場合は、そのピルシートの最終日で予測する最終服用日を記録する
      if (takenDate.isAfter(pillSheet.estimatedEndTakenDate)) {
        return pillSheet._updatedLastTakenDate(pillSheet.estimatedEndTakenDate);
      }

      // takenDateがピルシートの開始日に満たない場合は、記録の対象になっていないので早期リターン
      // 一つ前のピルシートのピルをタップした時など
      if (takenDate.date().isBefore(pillSheet.beginingDate.date())) {
        return pillSheet;
      }

      return pillSheet._updatedLastTakenDate(takenDate);
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
      // NOTE: avoid error for unit test
      if (Firebase.apps.isNotEmpty) {
        errorLogger.recordError(const FormatException("unexpected updatedIndexes is empty"), StackTrace.current);
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

    // 服用記録はBackendの通知等によく使われるので、DBに書き込まれたあとにStreamを通じてUIを更新する
    awaitsPillSheetGroupRemoteDBDataChanged = true;
    await batch.commit();

    return updatedPillSheetGroup;
  }
}

extension on PillSheet {
  PillSheet _updatedLastTakenDate(DateTime date) {
    return copyWith(
      lastTakenDate: date,
      pills: pills.map((pill) {
        if (pill.index > todayPillIndex) {
          return pill;
        }
        if (pill.pillTakens.length == pillTakenCount) {
          return pill;
        }
        final pillTakens = [...pill.pillTakens].sublist(0, pill.pillTakens.length);

        if (pill.index != todayPillIndex) {
          // NOTE: 今日以外のピルは、今日のピルを飲んだ時点で、今日のピルの服用記録を追加する
          for (var i = pill.pillTakens.length; i < pillTakenCount; i++) {
            pillTakens.add(PillTaken(
              takenDateTime: date,
              revertedDateTime: null,
              createdDateTime: now(),
              updatedDateTime: now(),
            ));
          }
        } else {
          // pill == todayPillIndex
          // NOTE: 今日のピルは、今日のピルを飲んだ時点で、今日のピルの服用記録を追加する
          pillTakens.add(PillTaken(
            takenDateTime: date,
            revertedDateTime: null,
            createdDateTime: now(),
            updatedDateTime: now(),
          ));
        }
        return pill.copyWith(pillTakens: pillTakens);
      }).toList(),
    );
  }
}
