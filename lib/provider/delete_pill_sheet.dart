import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:riverpod/riverpod.dart';

final deletePillSheetGroupProvider = Provider(
  (ref) => DeletePillSheetGroup(
    ref.watch(batchFactoryProvider),
    ref.watch(batchSetPillSheetModifiedHistoryProvider),
    ref.watch(batchSetPillSheetGroupProvider),
  ),
);

class DeletePillSheetGroup {
  final BatchFactory batchFactory;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;

  DeletePillSheetGroup(this.batchFactory, this.batchSetPillSheetModifiedHistory, this.batchSetPillSheetGroup);

  Future<void> call({
    required PillSheetGroup latestPillSheetGroup,
    required PillSheet activedPillSheet,
  }) async {
    final batch = batchFactory.batch();
    final updatedPillSheet = activedPillSheet.copyWith(deletedAt: DateTime.now());
    final updatedPillSheetGroup = latestPillSheetGroup.replaced(updatedPillSheet).copyWith(deletedAt: DateTime.now());
    final history = PillSheetModifiedHistoryServiceActionFactory.createDeletedPillSheetAction(
      pillSheetGroupID: latestPillSheetGroup.id,
      pillSheetIDs: latestPillSheetGroup.pillSheetIDs,
    );
    batchSetPillSheet(batch, updatedPillSheet);
    batchSetPillSheetModifiedHistory(batch, history);
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);
    await batch.commit();
  }
}
