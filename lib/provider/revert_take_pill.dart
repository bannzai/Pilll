import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final revertTakePillProvider = Provider.autoDispose(
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

  RevertTakePill({required this.batchFactory, required this.batchSetPillSheetModifiedHistory, required this.batchSetPillSheetGroup});

  Future<PillSheetGroup?> call({
    required PillSheetGroup pillSheetGroup,
    required int pageIndex,
    required int targetRevertPillNumberIntoPillSheet,
  }) async {
    final activePillSheet = pillSheetGroup.activePillSheet;
    if (activePillSheet == null) {
      throw FormatException(L.currentPillSheetNotFound);
    }
    if (pillSheetGroup.lastActiveRestDuration != null) {
      throw FormatException(L.doNotRevertTakePillInPausePeriod);
    }

    final targetPillSheet = pillSheetGroup.pillSheets[pageIndex];
    final targetPillDate = targetPillSheet.displayPillTakeDate(targetRevertPillNumberIntoPillSheet);
    final revertDate = targetPillDate.subtract(const Duration(days: 1)).date();

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

      if (revertDate.isBefore(pillSheet.beginDate)) {
        // reset pill sheet when back to one before pill sheet
        // 全ピルをリセットするケースではlastTakenDateをnullに戻す
        // 服用記録を全て取り消してlastTakenDateをnullにしたPillSheetを返す
        // v2の場合、lastTakenDateはpillsから導出されるため、pillTakensを空にするだけで良い
        switch (pillSheet) {
          case PillSheetV1():
            return pillSheet.copyWith(lastTakenDate: null, restDurations: []);
          case PillSheetV2():
            return pillSheet.copyWith(
              pills: pillSheet.pills.map((pill) => pill.copyWith(pillTakens: [])).toList(),
              restDurations: [],
            );
        }
      } else {
        // Revert対象の日付よりも後ろにある休薬期間のデータは消す
        final remainingResetDurations = pillSheet.restDurations.where((restDuration) => restDuration.beginDate.date().isBefore(revertDate)).toList();
        return pillSheet.revertedPillSheet(revertDate).copyWith(restDurations: remainingResetDurations);
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

    final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
      beforePillSheetGroup: pillSheetGroup,
      afterPillSheetGroup: updatedPillSheetGroup,
    );
    batchSetPillSheetModifiedHistory(batch, history);

    await batch.commit();

    return updatedPillSheetGroup;
  }
}

/// PillSheetから服用記録を取り消すためのextension
extension RevertedPillSheet on PillSheet {
  /// 服用記録を取り消したPillSheetを返す
  PillSheet revertedPillSheet(DateTime toDate) {
    return switch (this) {
      PillSheetV1 v1 => v1.copyWith(lastTakenDate: toDate),
      PillSheetV2 v2 => v2._revertedPillSheetV2(toDate),
    };
  }
}

/// PillSheetV2専用のextension（内部実装用）
extension _RevertedPillSheetV2 on PillSheetV2 {
  /// v2: pills を更新（lastTakenDateはpillsから導出されるため更新不要）
  /// toDateより後の全てのピルの服用記録をクリアする
  PillSheet _revertedPillSheetV2(DateTime toDate) {
    return copyWith(
      pills: pills.map((pill) {
        // toDateより後の日付のピルの服用記録をクリアする
        final dateOfPill = dates[pill.index];
        if (dateOfPill.isBefore(toDate) || isSameDay(dateOfPill, toDate)) {
          return pill;
        }

        return pill.copyWith(pillTakens: []);
      }).toList(),
    );
  }
}
