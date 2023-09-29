import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final addPillSheetGroupProvider = Provider.autoDispose(
  (ref) => AddPillSheetGroup(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
    batchSetSetting: ref.watch(batchSetSettingProvider),
  ),
);

class AddPillSheetGroup {
  final BatchFactory batchFactory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;

  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;
  final BatchSetSetting batchSetSetting;

  AddPillSheetGroup({
    required this.batchFactory,
    required this.batchSetPillSheetGroup,
    required this.batchSetPillSheetModifiedHistory,
    required this.batchSetSetting,
  });

  Future<void> call({
    required Setting setting,
    required PillSheetGroup? pillSheetGroup,
    required List<PillSheetType> pillSheetTypes,
    required PillSheetGroupDisplayNumberSetting? displayNumberSetting,
  }) async {
    final batch = batchFactory.batch();
    final updatedPillSheetGroup = buildPillSheetGroup(
      setting: setting,
      pillSheetGroup: pillSheetGroup,
      pillSheetTypes: pillSheetTypes,
      displayNumberSetting: displayNumberSetting,
    );
    final createdPillSheetGroup = batchSetPillSheetGroup(
      batch,
      updatedPillSheetGroup,
    );

    final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
      beforePillSheetGroup: pillSheetGroup,
      createdNewPillSheetGroup: createdPillSheetGroup,
      pillSheetIDs: updatedPillSheetGroup.pillSheetIDs,
      pillSheetGroupID: createdPillSheetGroup.id,
    );
    batchSetPillSheetModifiedHistory(batch, history);

    batchSetSetting(
        batch,
        setting.copyWith(
          pillSheetTypes: pillSheetTypes,
        ));

    await batch.commit();
  }
}

PillSheetGroup buildPillSheetGroup({
  required Setting setting,
  required PillSheetGroup? pillSheetGroup,
  required List<PillSheetType> pillSheetTypes,
  required PillSheetGroupDisplayNumberSetting? displayNumberSetting,
}) {
  final n = now();
  final createdPillSheets = pillSheetTypes.asMap().keys.map((pageIndex) {
    final pillSheetType = backportPillSheetTypes(pillSheetTypes)[pageIndex];
    final offset = summarizedPillCountWithPillSheetTypesToIndex(pillSheetTypes: pillSheetTypes, toIndex: pageIndex);
    return PillSheet(
      id: firestoreIDGenerator(),
      typeInfo: pillSheetType.typeInfo,
      beginingDate: n.add(
        Duration(days: offset),
      ),
      lastTakenDate: null,
      groupIndex: pageIndex,
      createdAt: now(),
    );
  }).toList();

  final pillSheetIDs = createdPillSheets.map((e) => e.id!).toList();
  final updatedPillSheetGroup = PillSheetGroup(
    pillSheetIDs: pillSheetIDs,
    pillSheets: createdPillSheets,
    displayNumberSetting: () {
      if (setting.pillSheetAppearanceMode == PillSheetAppearanceMode.sequential) {
        if (displayNumberSetting != null) {
          return displayNumberSetting;
        }
        if (pillSheetGroup != null) {
          return PillSheetGroupDisplayNumberSetting(
            beginPillNumber: pillSheetGroup.estimatedEndPillNumber + 1,
          );
        }
      }
      return null;
    }(),
    createdAt: now(),
  );

  return updatedPillSheetGroup;
}
