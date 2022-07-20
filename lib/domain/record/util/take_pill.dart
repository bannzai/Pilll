import 'package:pilll/database/batch.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/database/pill_sheet.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/util/datetime/date_compare.dart';

class TakePill {
  final PillSheetGroup pillSheetGroup;
  final PillSheet activedPillSheet;
  final BatchFactory batchFactory;
  final PillSheetDatastore pillSheetDatastore;
  final PillSheetModifiedHistoryDatastore pillSheetModifiedHistoryDatastore;
  final PillSheetGroupDatastore pillSheetGroupDatastore;

  TakePill({
    required this.pillSheetGroup,
    required this.activedPillSheet,
    required this.batchFactory,
    required this.pillSheetDatastore,
    required this.pillSheetModifiedHistoryDatastore,
    required this.pillSheetGroupDatastore,
  });

  Future<PillSheetGroup?> call({required DateTime takenDate, required bool isQuickRecord}) async {
    if (activedPillSheet.todayPillIsAlreadyTaken) {
      return null;
    }

    final batch = batchFactory.batch();

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
        return pillSheet.copyWith(lastTakenDate: pillSheet.estimatedEndTakenDate);
      } else {
        return pillSheet.copyWith(lastTakenDate: takenDate);
      }
    }).toList();

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
        if (index > 0) {
          final previousUpdatedPillSheet = updatedPillSheetGroup.pillSheets[index - 1];
          final previousUpdatedPillSheetLastTakenDate = previousUpdatedPillSheet.lastTakenDate;
          assert(previousUpdatedPillSheetLastTakenDate != null, "事前処理でnullではないはず。previousUpdatedPillSheetLastTakenDate != null");
          if (previousUpdatedPillSheetLastTakenDate != null) {
            if (isSameDay(previousUpdatedPillSheetLastTakenDate, takenDate)) {
              final updatedPillSheetLastTakenDate = updatedPillSheet.lastTakenDate;
              assert(updatedPillSheetLastTakenDate != null, "事前処理でnullではないはず。updatedPillSheetLastTakenDate != null");
              if (updatedPillSheetLastTakenDate != null) {
                if (isSameDay(previousUpdatedPillSheetLastTakenDate, updatedPillSheetLastTakenDate)) {
                  return false;
                }
              }
            }
          }
        }
      }

      return true;
    }).toList();

    if (updatedIndexses.isEmpty) {
      errorLogger.recordError(const FormatException("unexpected updatedIndexes is empty"), StackTrace.current);
      return null;
    }

    pillSheetDatastore.update(
      batch,
      updatedPillSheets,
    );
    pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup);

    final before = pillSheetGroup.pillSheets[updatedIndexses.first];
    final after = updatedPillSheetGroup.pillSheets[updatedIndexses.last];
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
