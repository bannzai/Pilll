import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';

final beginRestDurationProvider = Provider.autoDispose(
  (ref) => BeginRestDuration(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
  ),
);

class BeginRestDuration {
  final BatchFactory batchFactory;

  final BatchSetPillSheetGroup batchSetPillSheetGroup;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;

  BeginRestDuration({
    required this.batchFactory,
    required this.batchSetPillSheetGroup,
    required this.batchSetPillSheetModifiedHistory,
  });

  Future<void> call({
    required PillSheetGroup pillSheetGroup,
  }) async {
    final batch = batchFactory.batch();

    final RestDuration restDuration;
    final lastTakenDate = pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.lastTakenDate;
    if (lastTakenDate == null) {
      // 1番目から服用お休みする場合は、beginDateは今日になる
      restDuration = RestDuration(
        beginDate: now(),
        createdDate: now(),
      );
    } else {
      restDuration = RestDuration(
        beginDate: lastTakenDate.addDays(1),
        createdDate: now(),
      );
    }
    final updatedPillSheet = pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.copyWith(
      restDurations: [...pillSheetGroup.lastTakenPillSheetOrFirstPillSheet.restDurations, restDuration],
    );
    final updatedPillSheetGroup = pillSheetGroup.replaced(updatedPillSheet);

    batchSetPillSheetGroup(batch, updatedPillSheetGroup);
    batchSetPillSheetModifiedHistory(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
        pillSheetGroupID: pillSheetGroup.id,
        before: pillSheetGroup.lastTakenPillSheetOrFirstPillSheet,
        after: updatedPillSheet,
        restDuration: restDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      ),
    );

    await batch.commit();
  }
}

final endRestDurationProvider = Provider.autoDispose(
  (ref) => EndRestDuration(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
  ),
);

class EndRestDuration {
  final BatchFactory batchFactory;

  final BatchSetPillSheetGroup batchSetPillSheetGroup;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;

  EndRestDuration({
    required this.batchFactory,
    required this.batchSetPillSheetGroup,
    required this.batchSetPillSheetModifiedHistory,
  });

  Future<PillSheetGroup> call({
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
        // activePillSheetよりも後のピルシートで、前のピルシートのbeginDateが更新され、estimatedEndTakenDateが変わっている場合も考慮する必要があるのでupdatedPillSheetsから1つ前のピルシートにアクセスする
        final beforeUpdatedPillSheet = updatedPillSheets[pillSheet.groupIndex - 1];
        updatedPillSheets.add(pillSheet.copyWith(
          beginingDate: beforeUpdatedPillSheet.estimatedEndTakenDate.add(const Duration(days: 1)),
        ));
      } else {
        updatedPillSheets.add(pillSheet);
      }
    }

    final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);
    batchSetPillSheetModifiedHistory(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createEndedRestDurationAction(
        pillSheetGroupID: pillSheetGroup.id,
        before: activePillSheet,
        after: updatedPillSheet,
        restDuration: updatedRestDuration,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      ),
    );
    await batch.commit();

    return updatedPillSheetGroup;
  }
}
