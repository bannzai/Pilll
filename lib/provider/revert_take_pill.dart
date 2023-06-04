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

  Future<PillSheetGroup?> call({required PillSheetGroup pillSheetGroup, required int pageIndex, required int pillNumberIntoPillSheet}) async {
    final activedPillSheet = pillSheetGroup.activedPillSheet;
    if (activedPillSheet == null) {
      throw const FormatException("現在対象となっているピルシートが見つかりませんでした");
    }
    if (activedPillSheet.activeRestDuration != null) {
      throw const FormatException("ピルの服用の取り消し操作は休薬期間中は実行できません");
    }

    final targetPillSheet = pillSheetGroup.pillSheets[pageIndex];
    final takenDate = targetPillSheet.pillTakenDateFromPillNumber(pillNumberIntoPillSheet).subtract(const Duration(days: 1)).date();

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
        return pillSheet._updatedLastTakenDate(pillSheet.beginingDate.subtract(const Duration(days: 1)).date()).copyWith(restDurations: []);
      } else {
        // Revert対象の日付よりも後ろにある休薬期間のデータは消す
        final remainingResetDurations = pillSheet.restDurations.where((restDuration) => restDuration.beginDate.date().isBefore(takenDate)).toList();
        return pillSheet._updatedLastTakenDate(takenDate).copyWith(
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

extension on PillSheet {
  PillSheet _updatedLastTakenDate(DateTime date) {
    return copyWith(
      lastTakenDate: date,
      pills: pills.map((pill) {
        if (pill.index > todayPillIndex) {
          return pill;
        }
        final pillTakenList = [...pill.pillTakens];

        if (isSameDay(date.date(), today()) && pill.index == todayPillIndex) {
          // 対象が今日のピルの場合、取り消すのは最後の1回の服用記録
          if (pillTakenList.isEmpty) {
            return pill;
          }

          pillTakenList.removeLast();
          return pill.copyWith(pillTakens: pillTakenList);
        }

        if (beginingDate.date().add(Duration(days: pill.index)).isBefore(date)) {
          return pill;
        }

        // NOTE: !isSameDay(date.date() ,today()) && pill.index == todayPillIndex
        // OR pill.index != todayPillIndex。これらの場合は全ての服用記録を消す
        return pill.copyWith(pillTakens: []);
      }).toList(),
    );
  }
}
