import 'package:pilll/database/batch.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/database/pill_sheet.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';

Future<PillSheetGroup?> take({
  required DateTime takenDate,
  required PillSheetGroup pillSheetGroup,
  required PillSheet activedPillSheet,
  required BatchFactory batchFactory,
  required PillSheetDatastore pillSheetDatastore,
  required PillSheetModifiedHistoryDatastore pillSheetModifiedHistoryDatastore,
  required PillSheetGroupDatastore pillSheetGroupDatastore,
  required bool isQuickRecord,
}) async {
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

    // takenDateよりも予測するピルシートの最終服用日よりじも大きい場合はactivedPillSheetじゃないPillSheetと判断。
    // そのピルシートの最終日で予測する最終服用日を記録する
    if (takenDate.isAfter(pillSheet.estimatedEndTakenDate)) {
      return pillSheet.copyWith(lastTakenDate: pillSheet.estimatedEndTakenDate);
    } else {
      return pillSheet.copyWith(lastTakenDate: takenDate);
    }
  }).toList();

  final updatedPillSheetGroup =
      pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
  final updatedIndexses = pillSheetGroup.pillSheets.asMap().keys.where((index) {
    final updatedPillSheet = updatedPillSheetGroup.pillSheets[index];
    if (pillSheetGroup.pillSheets[index] == updatedPillSheet) {
      return false;
    }

    // 例えば2枚目のピルシート(groupIndex:1)がアクティブで、1枚目のピルシート(groupIndex:0)が最終日を記録した場合(28番目)、2枚目のピルシートのlastTakenDateが1枚目の28番目のピルシートのlastTakenDateと同じになる。
    // その場合後続の処理で決定する履歴のafter: PillSheetの値が2枚目のピルシートの値になってしまう。これを避けるための条件式になっている
    final updatedPillSheetLastTakenDate = updatedPillSheet.lastTakenDate;
    if (updatedPillSheet.groupIndex == activedPillSheet.groupIndex &&
        updatedPillSheetLastTakenDate != null &&
        updatedPillSheet.beginingDate.isAfter(updatedPillSheetLastTakenDate)) {
      return false;
    }

    return true;
  }).toList();

  if (updatedIndexses.isEmpty) {
    return null;
  }

  pillSheetDatastore.update(
    batch,
    updatedPillSheets,
  );
  pillSheetGroupDatastore.updateWithBatch(batch, updatedPillSheetGroup);

  final before = pillSheetGroup.pillSheets[updatedIndexses.first];
  final after = updatedPillSheetGroup.pillSheets[updatedIndexses.last];
  final history =
      PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
    pillSheetGroupID: pillSheetGroup.id,
    before: before,
    after: after,
    isQuickRecord: isQuickRecord,
  );
  pillSheetModifiedHistoryDatastore.add(batch, history);

  await batch.commit();

  return updatedPillSheetGroup;
}
