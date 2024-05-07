import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/date_compare.dart';
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

    final restDuration = RestDuration(
      id: firestoreIDGenerator(),
      beginDate: pillSheetGroup.availableRestDurationBeginDate(),
      createdDate: now(),
    );

    final updatedPillSheet = pillSheetGroup.targetBeginRestDurationPillSheet.copyWith(
      restDurations: [
        ...pillSheetGroup.targetBeginRestDurationPillSheet.restDurations,
        restDuration,
      ],
    );
    final updatedPillSheetGroup = pillSheetGroup.replaced(updatedPillSheet);

    batchSetPillSheetGroup(batch, updatedPillSheetGroup);
    batchSetPillSheetModifiedHistory(
      batch,
      PillSheetModifiedHistoryServiceActionFactory.createBeganRestDurationAction(
        pillSheetGroupID: pillSheetGroup.id,
        before: pillSheetGroup.targetBeginRestDurationPillSheet,
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

final changeRestDurationBeginDateProvider = Provider.autoDispose(
  (ref) => ChangeRestDuration(
    actionType: PillSheetModifiedActionType.changedRestDurationBeginDate,
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
  ),
);
final changeRestDurationProvider = Provider.autoDispose(
  (ref) => ChangeRestDuration(
    actionType: PillSheetModifiedActionType.changedRestDuration,
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
  ),
);

class ChangeRestDuration {
  // changedRestDurationBeginDate or changedRestDuration
  final PillSheetModifiedActionType actionType;
  final BatchFactory batchFactory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;
  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;

  ChangeRestDuration({
    required this.actionType,
    required this.batchFactory,
    required this.batchSetPillSheetGroup,
    required this.batchSetPillSheetModifiedHistory,
  });

  bool _hasRestDuration(PillSheet pillSheet, RestDuration restDuration) {
    // restDuration.idが2024-03-28の実装時に追加されたものでnullableの可能性がある。
    // idチェックをしているが後述の期間をチェックする処理でもほぼ問題ない
    // また、toRestDurationの場合はマッチするIDが無いのでどちらにしてもidではなく期間で絞る必要がある
    if (pillSheet.restDurations.map((e) => e.id).where((e) => e != null).contains(restDuration.id)) {
      return true;
    }
    return !restDuration.beginDate.isBefore(pillSheet.beginingDate) && !restDuration.beginDate.isAfter(pillSheet.estimatedEndTakenDate);
  }

  Future<void> call({
    required RestDuration fromRestDuration,
    required RestDuration toRestDuration,
    required PillSheetGroup pillSheetGroup,
  }) async {
    final fromRestDurationPillSheetIndex = pillSheetGroup.pillSheets.indexWhere((e) => _hasRestDuration(e, fromRestDuration));
    if (fromRestDurationPillSheetIndex == -1) {
      throw AssertionError("fromRestDurationPillSheetIndex is not found");
    }
    final fromRestDurationPillSheet = pillSheetGroup.pillSheets[fromRestDurationPillSheetIndex];
    if (fromRestDurationPillSheet.restDurations.isEmpty) {
      throw AssertionError("fromRestDurationPillSheet.restDurations is empty");
    }
    final fromRestDurationIndex = fromRestDurationPillSheet.restDurations.indexOf(fromRestDuration);
    if (fromRestDurationIndex == -1) {
      throw AssertionError("fromRestDurationIndex is not found");
    }
    final updatedFromRestDurationPillSheet =
        fromRestDurationPillSheet.copyWith(restDurations: [...fromRestDurationPillSheet.restDurations]..removeAt(fromRestDurationIndex));

    final toRestDurationPillSheetIndex = pillSheetGroup.pillSheets.indexWhere((e) => _hasRestDuration(e, toRestDuration));
    if (toRestDurationPillSheetIndex == -1) {
      throw AssertionError("toRestDurationPillSheetIndex is not found");
    }
    final PillSheet updatedToRestDurationPillSheet;
    final toRestDurationPillSheet = pillSheetGroup.pillSheets[toRestDurationPillSheetIndex];
    if (updatedFromRestDurationPillSheet.id == toRestDurationPillSheet.id) {
      // 変更前後のお休み期間対象のピルシートが一緒の場合はupdatedFromRestDurationPillSheetからコピーする
      updatedToRestDurationPillSheet = updatedFromRestDurationPillSheet.copyWith(
        restDurations: [...updatedFromRestDurationPillSheet.restDurations, toRestDuration],
      );
    } else {
      updatedToRestDurationPillSheet = toRestDurationPillSheet.copyWith(
        restDurations: [...toRestDurationPillSheet.restDurations, toRestDuration],
      );
    }

    // 先に服用お休み期間を更新する
    // 後述のループでbeginDateを更新する
    final updatedRestDurationPillSheets = <PillSheet>[];
    for (final pillSheet in pillSheetGroup.pillSheets) {
      // updatedToRestDurationPillSheet からチェックする。updatedFromRestDurationPillSheet.id == toRestDurationPillSheet.id の場合は
      // if (pillSheet.id == updatedFromRestDurationPillSheet.id)の条件式には引っかからない
      if (pillSheet.id == updatedToRestDurationPillSheet.id) {
        updatedRestDurationPillSheets.add(updatedToRestDurationPillSheet);
      } else if (pillSheet.id == updatedFromRestDurationPillSheet.id) {
        updatedRestDurationPillSheets.add(updatedFromRestDurationPillSheet);
      } else {
        updatedRestDurationPillSheets.add(pillSheet);
      }
    }

    final updatedPillSheets = <PillSheet>[];
    for (final pillSheet in updatedRestDurationPillSheets) {
      if (pillSheet.id == updatedRestDurationPillSheets.first.id) {
        updatedPillSheets.add(pillSheet);
        continue;
      }
      final beforePillSheet = updatedRestDurationPillSheets[pillSheet.groupIndex - 1];
      updatedPillSheets.add(pillSheet.copyWith(
        beginingDate: beforePillSheet.estimatedEndTakenDate.add(const Duration(days: 1)),
      ));
    }

    final batch = batchFactory.batch();
    final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);
    switch (actionType) {
      case PillSheetModifiedActionType.changedRestDurationBeginDate:
        batchSetPillSheetModifiedHistory(
          batch,
          PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationBeginDateAction(
            pillSheetGroupID: pillSheetGroup.id,
            before: fromRestDurationPillSheet,
            after: updatedToRestDurationPillSheet,
            beforeRestDuration: fromRestDuration,
            afterRestDuration: toRestDuration,
            beforePillSheetGroup: pillSheetGroup,
            afterPillSheetGroup: updatedPillSheetGroup,
          ),
        );
      case PillSheetModifiedActionType.changedRestDuration:
        batchSetPillSheetModifiedHistory(
          batch,
          PillSheetModifiedHistoryServiceActionFactory.createChangedRestDurationAction(
            pillSheetGroupID: pillSheetGroup.id,
            before: fromRestDurationPillSheet,
            after: updatedToRestDurationPillSheet,
            beforeRestDuration: fromRestDuration,
            afterRestDuration: toRestDuration,
            beforePillSheetGroup: pillSheetGroup,
            afterPillSheetGroup: updatedPillSheetGroup,
          ),
        );
      default:
        throw AssertionError("actionType is not supported: $actionType");
    }

    await batch.commit();
  }
}
