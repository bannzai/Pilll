import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/database/batch.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/provider/pill_sheet.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/util/datetime/day.dart';

final changePillNumberProvider = Provider(
  (ref) => ChangePillNumber(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheets: ref.watch(batchSetPillSheetsProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
  ),
);

class ChangePillNumber {
  final BatchFactory batchFactory;
  final BatchSetPillSheets batchSetPillSheets;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;

  ChangePillNumber({
    required this.batchFactory,
    required this.batchSetPillSheets,
    required this.batchSetPillSheetModifiedHistory,
    required this.batchSetPillSheetGroup,
  });

  void call({
    required PillSheetGroup pillSheetGroup,
    required PillSheet activedPillSheet,
    required int pillSheetPageIndex,
    required int pillNumberIntoPillSheet,
  }) async {
    final batch = batchFactory.batch();

    final pillSheetTypes = pillSheetGroup.pillSheets.map((e) => e.pillSheetType).toList();
    final nextSerializedPillNumber = summarizedPillCountWithPillSheetTypesToEndIndex(
          pillSheetTypes: pillSheetTypes,
          endIndex: pillSheetPageIndex,
        ) +
        pillNumberIntoPillSheet;
    final firstPilSheetBeginDate = today().subtract(Duration(days: nextSerializedPillNumber - 1));

    final List<PillSheet> updatedPillSheets = [];
    pillSheetGroup.pillSheets.asMap().keys.forEach((index) {
      final pillSheet = pillSheetGroup.pillSheets[index];

      final DateTime beginDate;
      if (index == 0) {
        beginDate = firstPilSheetBeginDate;
      } else {
        final passedTotalCount = summarizedPillCountWithPillSheetTypesToEndIndex(pillSheetTypes: pillSheetTypes, endIndex: index);
        beginDate = firstPilSheetBeginDate.add(Duration(days: passedTotalCount));
      }

      final DateTime? lastTakenDate;
      if (pillSheetPageIndex == index) {
        lastTakenDate = beginDate.add(Duration(days: pillNumberIntoPillSheet - 2));
      } else if (pillSheetPageIndex > index) {
        lastTakenDate = beginDate.add(Duration(days: pillSheet.pillSheetType.totalCount - 1));
      } else {
        // state.selectedPillMarkNumberIntoPillSheet < index
        lastTakenDate = null;
      }

      final updatedPillSheet = pillSheet.copyWith(beginingDate: beginDate, lastTakenDate: lastTakenDate, restDurations: []);
      updatedPillSheets.add(updatedPillSheet);
    });

    batchSetPillSheets(batch, updatedPillSheets);

    final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
      pillSheetGroupID: pillSheetGroup.id,
      before: activedPillSheet,
      after: updatedPillSheets[pillSheetPageIndex],
    );
    batchSetPillSheetModifiedHistory(batch, history);
    batchSetPillSheetGroup(batch, pillSheetGroup.copyWith(pillSheets: updatedPillSheets));

    await batch.commit();
  }
}
