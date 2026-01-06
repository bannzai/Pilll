import 'package:flutter/cupertino.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:riverpod/riverpod.dart';

final removeOnePillTakenProvider = Provider.autoDispose(
  (ref) => RemoveOnePillTaken(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
  ),
);

/// 指定したピルの服用記録を1つだけ削除するクラス
class RemoveOnePillTaken {
  final BatchFactory batchFactory;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;

  RemoveOnePillTaken({
    required this.batchFactory,
    required this.batchSetPillSheetModifiedHistory,
    required this.batchSetPillSheetGroup,
  });

  Future<PillSheetGroup?> call({
    required PillSheetGroup pillSheetGroup,
    required int pageIndex,
    required int pillNumberInPillSheet,
  }) async {
    final activePillSheet = pillSheetGroup.activePillSheet;
    if (activePillSheet == null) {
      throw FormatException(L.currentPillSheetNotFound);
    }
    if (pillSheetGroup.lastActiveRestDuration != null) {
      throw FormatException(L.doNotRevertTakePillInPausePeriod);
    }

    final targetPillSheet = pillSheetGroup.pillSheets[pageIndex];

    // V1の場合は従来のrevert処理にフォールバック
    if (targetPillSheet is! PillSheetV2) {
      debugPrint('RemoveOnePillTaken: V1 pill sheet, falling back to revert');
      return null;
    }

    final pillIndex = pillNumberInPillSheet - 1;
    if (pillIndex < 0 || pillIndex >= targetPillSheet.pills.length) {
      debugPrint('RemoveOnePillTaken: Invalid pill index');
      return null;
    }

    final pill = targetPillSheet.pills[pillIndex];
    if (pill.pillTakens.isEmpty) {
      debugPrint('RemoveOnePillTaken: No pill taken to remove');
      return null;
    }

    // pillTakensから最後の1つを削除
    final updatedPillTakens = List<PillTaken>.from(pill.pillTakens)..removeLast();
    final updatedPill = pill.copyWith(pillTakens: updatedPillTakens);

    // pillsを更新
    final updatedPills = List<Pill>.from(targetPillSheet.pills);
    updatedPills[pillIndex] = updatedPill;

    // lastTakenDateを再計算
    final newLastTakenDate = _calculateLastTakenDate(targetPillSheet, updatedPills);

    final updatedPillSheet = targetPillSheet.copyWith(
      pills: updatedPills,
      lastTakenDate: newLastTakenDate,
    );

    // pillSheetsを更新
    final updatedPillSheets = List<PillSheet>.from(pillSheetGroup.pillSheets);
    updatedPillSheets[pageIndex] = updatedPillSheet;

    final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);

    final batch = batchFactory.batch();
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);

    final history = PillSheetModifiedHistoryServiceActionFactory.createRevertTakenPillAction(
      pillSheetGroupID: pillSheetGroup.id,
      before: targetPillSheet,
      after: updatedPillSheet,
      beforePillSheetGroup: pillSheetGroup,
      afterPillSheetGroup: updatedPillSheetGroup,
    );
    batchSetPillSheetModifiedHistory(batch, history);

    await batch.commit();

    return updatedPillSheetGroup;
  }

  /// 更新されたpillsからlastTakenDateを再計算する
  DateTime? _calculateLastTakenDate(PillSheetV2 pillSheet, List<Pill> updatedPills) {
    // 最後に服用記録があるピルを探す
    for (int i = updatedPills.length - 1; i >= 0; i--) {
      if (updatedPills[i].pillTakens.isNotEmpty) {
        // そのピルの日付を返す
        return pillSheet.dates[i];
      }
    }
    // 服用記録がない場合はnull
    return null;
  }
}
