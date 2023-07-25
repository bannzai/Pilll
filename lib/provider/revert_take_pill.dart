import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final revertTakePillProvider = Provider(
  (ref) => RevertTakePill(
    batchFactory: ref.watch(batchFactoryProvider),
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

  Future<PillSheetGroup?> call({
    required PillSheetGroup pillSheetGroup,
    required int pageIndex,
    required int targetRevertPillNumberIntoPillSheet,
  }) async {
    final activePillSheet = pillSheetGroup.activePillSheet;
    if (activePillSheet == null) {
      throw const FormatException("現在対象となっているピルシートが見つかりませんでした");
    }
    if (activePillSheet.activeRestDuration != null) {
      throw const FormatException("ピルの服用の取り消し操作は休薬期間中は実行できません");
    }

    final targetPillSheet = pillSheetGroup.pillSheets[pageIndex];
    final revertDate = targetPillSheet.pillTakenDateFromPillNumber(targetRevertPillNumberIntoPillSheet).subtract(const Duration(days: 1)).date();

    final updatedPillSheets = pillSheetGroup.pillSheets.map((pillSheet) {
      final lastTakenDate = pillSheet.lastTakenDate;
      if (lastTakenDate == null) {
        return pillSheet;
      }
      if (revertDate.isAfter(lastTakenDate)) {
        return pillSheet;
      }

      if (pillSheet.groupIndex > activePillSheet.groupIndex) {
        return pillSheet;
      }
      if (pillSheet.groupIndex < pageIndex) {
        return pillSheet;
      }

      if (revertDate.isBefore(pillSheet.beginingDate)) {
        // reset pill sheet when back to one before pill sheet
        return pillSheet.revertedPillSheet(pillSheet.beginingDate.subtract(const Duration(days: 1)).date()).copyWith(restDurations: []);
      } else {
        // Revert対象の日付よりも後ろにある休薬期間のデータは消す
        final remainingResetDurations = pillSheet.restDurations.where((restDuration) => restDuration.beginDate.date().isBefore(revertDate)).toList();
        return pillSheet.revertedPillSheet(revertDate).copyWith(
              restDurations: remainingResetDurations,
            );
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
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);

    final before = pillSheetGroup.pillSheets[updatedIndexses.last];
    final after = updatedPillSheetGroup.pillSheets[updatedIndexses.first];
    final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
      pillSheetGroupID: pillSheetGroup.id,
      before: before,
      after: after,
      beforePillSheetGroup: pillSheetGroup,
      afterPillSheetGroup: updatedPillSheetGroup,
    );
    batchSetPillSheetModifiedHistory(batch, history);

    await batch.commit();

    return updatedPillSheetGroup;
  }
}

extension RevertedPillSheet on PillSheet {
  PillSheet revertedPillSheet(DateTime toDate) {
    return copyWith(
      lastTakenDate: toDate,
      pills: pills.map((pill) {
        // このpillの日付(begin + pill.index)が対象の日付よりも前の場合は何もしない
        final dateOfPill = beginingDate.date().add(Duration(days: pill.index));
        if (dateOfPill.isBefore(toDate) || isSameDay(dateOfPill, toDate)) {
          return pill;
        }

        // NOTE: !(isSameDay(date.date() ,today()) && pill.index == todayPillIndex)
        // OR pill.index != todayPillIndex。これらの場合は全ての服用記録を消す
        return pill.copyWith(pillTakens: []);
      }).toList(),
    );
  }
}
