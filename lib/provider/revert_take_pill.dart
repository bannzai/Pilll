import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/provider/pill_sheet.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final revertTakePillProvider = Provider(
  (ref) => RevertTakePill(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheets: ref.watch(batchSetPillSheetsProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
  ),
);

class RevertTakePill {
  final BatchFactory batchFactory;

  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;

  RevertTakePill({
    required this.batchFactory,
    required this.batchSetPillSheetModifiedHistory,
    required this.batchSetPillSheetGroup,
  });

  Future<PillSheetGroup?> call({required PillSheetGroup pillSheetGroup, required int pageIndex, required int pillNumberIntoPillSheet}) async {
    final activedPillSheet = pillSheetGroup.activedPillSheet;
    if (activedPillSheet == null) {
      throw const FormatException("現在対象となっているピルシートが見つかりませんでした");
    }
    if (activedPillSheet.activeRestDuration != null) {
      throw const FormatException("ピルの服用の取り消し操作は休薬期間中は実行できません");
    }

    final targetPillSheet = pillSheetGroup.pillSheets[pageIndex];
    final takenDate = targetPillSheet.displayPillTakeDate(pillNumberIntoPillSheet).subtract(const Duration(days: 1)).date();

    final updatedPillSheets = pillSheetGroup.pillSheets.map((pillSheet) {
      final lastTakenDate = pillSheet.lastTakenDate;
      if (lastTakenDate == null) {
        return pillSheet;
      }
      if (takenDate.isAfter(lastTakenDate)) {
        return pillSheet;
      }

      if (pillSheet.groupIndex > activedPillSheet.groupIndex) {
        return pillSheet;
      }
      if (pillSheet.groupIndex < pageIndex) {
        return pillSheet;
      }

      if (takenDate.isBefore(pillSheet.beginingDate)) {
        // reset pill sheet when back to one before pill sheet
        return pillSheet.copyWith(lastTakenDate: pillSheet.beginingDate.subtract(const Duration(days: 1)).date(), restDurations: []);
      } else {
        // Revert対象の日付よりも後ろにある休薬期間のデータは消す
        final remainingResetDurations = pillSheet.restDurations.where((restDuration) => restDuration.beginDate.date().isBefore(takenDate)).toList();
        return pillSheet.copyWith(lastTakenDate: takenDate, restDurations: remainingResetDurations);
      }
    }).toList();

    final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
    final updatedIndexses = pillSheetGroup.pillSheets.asMap().keys.where(
          (index) => pillSheetGroup.pillSheets[index] != updatedPillSheetGroup.pillSheets[index],
        );

    if (updatedIndexses.isEmpty) {
      return null;
    }

    final batch = batchFactory.batch();
    batchSetPillSheets(
      batch,
      updatedPillSheets,
    );
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);

    final before = pillSheetGroup.pillSheets[updatedIndexses.last];
    final after = updatedPillSheetGroup.pillSheets[updatedIndexses.first];
    final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
      pillSheetGroupID: pillSheetGroup.id,
      before: before,
      after: after,
    );
    batchSetPillSheetModifiedHistory(batch, history);

    await batch.commit();

    return updatedPillSheetGroup;
  }
}
