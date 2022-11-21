import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/provider/pill_sheet.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/day.dart';

final beginRestDurationProvider = Provider(
  (ref) => BeginRestDuration(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheets: ref.watch(batchSetPillSheetsProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
  ),
);

class BeginRestDuration {
  final BatchFactory batchFactory;
  final BatchSetPillSheets batchSetPillSheets;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;

  BeginRestDuration({
    required this.batchFactory,
    required this.batchSetPillSheets,
    required this.batchSetPillSheetGroup,
    required this.batchSetPillSheetModifiedHistory,
  });

  Future<void> call({
    required PillSheet activePillSheet,
    required PillSheetGroup pillSheetGroup,
  }) async {
    final batch = batchFactory.batch();

    final restDuration = RestDuration(
      beginDate: now(),
      createdDate: now(),
    );
    final updatedPillSheet = activePillSheet.copyWith(
      restDurations: [...activePillSheet.restDurations, restDuration],
    );
    final updatedPillSheetGroup = pillSheetGroup.replaced(updatedPillSheet);
    batchSetPillSheets(batch, updatedPillSheetGroup.pillSheets);
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);
    batchSetPillSheetModifiedHistory(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
        pillSheetGroupID: pillSheetGroup.id,
        before: activePillSheet,
        after: updatedPillSheet,
        restDuration: restDuration,
      ),
    );

    await batch.commit();
  }
}

final endRestDurationProvider = Provider(
  (ref) => EndRestDuration(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheets: ref.watch(batchSetPillSheetsProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
  ),
);

class EndRestDuration {
  final BatchFactory batchFactory;
  final BatchSetPillSheets batchSetPillSheets;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;

  EndRestDuration({
    required this.batchFactory,
    required this.batchSetPillSheets,
    required this.batchSetPillSheetGroup,
    required this.batchSetPillSheetModifiedHistory,
  });

  Future<void> call({
    required RestDuration restDuration,
    required PillSheet activePillSheet,
    required PillSheetGroup pillSheetGroup,
  }) async {
    final batch = batchFactory.batch();
    final updatedRestDuration = restDuration.copyWith(endDate: now());
    final updatedPillSheet = activePillSheet.copyWith(
      restDurations: [...activePillSheet.restDurations]..replaceRange(
          activePillSheet.restDurations.length - 1,
          activePillSheet.restDurations.length,
          [updatedRestDuration],
        ),
    );
    final updatedPillSheets = <PillSheet>[];
    for (final pillSheet in pillSheetGroup.pillSheets) {
      if (pillSheet.id == activePillSheet.id) {
        updatedPillSheets.add(updatedPillSheet);
      } else if (pillSheet.groupIndex > activePillSheet.groupIndex) {
        // 前回のピルシートのbeginDateが更新され、estimatedEndTakenDateが変わっている場合も考慮する必要があるのでupdatedPillSheetsでアクセスする
        final beforeUpdatedPillSheet = updatedPillSheets[pillSheet.groupIndex - 1];
        updatedPillSheets.add(pillSheet.copyWith(
          beginingDate: beforeUpdatedPillSheet.estimatedEndTakenDate.add(const Duration(days: 1)),
        ));
      } else {
        updatedPillSheets.add(pillSheet);
      }
    }
    batchSetPillSheets(batch, updatedPillSheets);
    batchSetPillSheetGroup(batch, pillSheetGroup.copyWith(pillSheets: updatedPillSheets));
    batchSetPillSheetModifiedHistory(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
        pillSheetGroupID: pillSheetGroup.id,
        before: activePillSheet,
        after: updatedPillSheet,
        restDuration: updatedRestDuration,
      ),
    );
    await batch.commit();
  }
}
