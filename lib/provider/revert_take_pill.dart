import 'package:flutter/cupertino.dart';
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
      throw FormatException(L.currentPillSheetNotFound);
    }
    if (pillSheetGroup.lastActiveRestDuration != null) {
      throw FormatException(L.doNotRevertTakePillInPausePeriod);
    }

    final targetPillSheet = pillSheetGroup.pillSheets[pageIndex];
    final revertDate = targetPillSheet.displayPillTakeDate(targetRevertPillNumberIntoPillSheet).subtract(const Duration(days: 1)).date();
    debugPrint('revertDate: $revertDate');

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

/// PillSheetから服用記録を取り消すためのextension
extension RevertedPillSheet on PillSheet {
  /// 服用記録を取り消したPillSheetを返す
  PillSheet revertedPillSheet(DateTime toDate) {
    switch (this) {
      case PillSheetV1():
        return _revertedPillSheetV1(toDate);
      case PillSheetV2():
        return _revertedPillSheetV2(toDate);
    }
  }

  /// v1: lastTakenDateのみを更新
  PillSheet _revertedPillSheetV1(DateTime toDate) {
    return copyWith(lastTakenDate: toDate);
  }

  /// v2: pills と lastTakenDate を更新
  /// toDateより後の全てのピルの服用記録をクリアする
  PillSheet _revertedPillSheetV2(DateTime toDate) {
    final v2 = this as PillSheetV2;
    final pills = v2.pills;

    return v2.copyWith(
      lastTakenDate: toDate,
      pills: pills.map((pill) {
        // このpillの日付が対象の日付よりも前の場合は何もしない
        // 休薬期間を考慮したdatesプロパティを使用
        final dateOfPill = dates[pill.index];
        if (dateOfPill.isBefore(toDate) || isSameDay(dateOfPill, toDate)) {
          debugPrint('early return pill: ${pill.index}');
          return pill;
        }

        // NOTE: !(isSameDay(date.date() ,today()) && pill.index == todayPillIndex)
        // OR pill.index != todayPillIndex。これらの場合は全ての服用記録を消す
        debugPrint('clear pill: ${pill.index}');
        return pill.copyWith(pillTakens: []);
      }).toList(),
    );
  }
}
