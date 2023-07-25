import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/day.dart';

final changePillNumberProvider = Provider(
  (ref) => ChangePillNumber(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
  ),
);

class ChangePillNumber {
  final BatchFactory batchFactory;

  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;

  ChangePillNumber({
    required this.batchFactory,
    required this.batchSetPillSheetModifiedHistory,
    required this.batchSetPillSheetGroup,
  });

  Future<void> call({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activePillSheet,
    required int pillSheetPageIndex,
    required int pillNumberInPillSheet,
  }) async {
    final batch = batchFactory.batch();

    final pillSheetTypes = pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();
    final nextSerializedPillNumber = summarizedPillCountWithPillSheetTypesToIndex(
          pillSheetTypes: pillSheetTypes,
          toIndex: pillSheetPageIndex,
        ) +
        pillNumberInPillSheet;
    final firstPilSheetBeginDate = today().subtract(Duration(days: nextSerializedPillNumber - 1));

    final List<PillSheet> updatedPillSheets = [];
    pillSheetGroup.pillSheets.asMap().keys.forEach((index) {
      final pillSheet = pillSheetGroup.pillSheets[index];

      final DateTime beginDate;
      if (index == 0) {
        beginDate = firstPilSheetBeginDate;
      } else {
        final passedTotalCount = summarizedPillCountWithPillSheetTypesToIndex(pillSheetTypes: pillSheetTypes, toIndex: index);
        beginDate = firstPilSheetBeginDate.add(Duration(days: passedTotalCount));
      }

      final DateTime? lastTakenDate;
      if (pillSheetPageIndex == index) {
        lastTakenDate = beginDate.add(Duration(days: pillNumberInPillSheet - 2));
      } else if (pillSheetPageIndex > index) {
        lastTakenDate = beginDate.add(Duration(days: pillSheet.pillSheetType.totalCount - 1));
      } else {
        // state.selectedPillMarkNumberIntoPillSheet < index
        lastTakenDate = null;
      }

      final updatedPillSheet = pillSheet.copyWith(beginingDate: beginDate, lastTakenDate: lastTakenDate, restDurations: []);
      updatedPillSheets.add(updatedPillSheet);
    });

    final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
    final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
      pillSheetGroupID: pillSheetGroup.id,
      before: activePillSheet,
      after: updatedPillSheets[pillSheetPageIndex],
      beforePillSheetGroup: pillSheetGroup,
      afterPillSheetGroup: updatedPillSheetGroup,
    );
    batchSetPillSheetModifiedHistory(batch, history);
    batchSetPillSheetGroup(
      batch,
      updatedPillSheetGroup,
    );

    await batch.commit();
  }
}
