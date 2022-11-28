import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/provider/pill_sheet.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final addPillSheetGroupProvider = Provider(
  (ref) => AddPillSheetGroup(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
    batchSetPillSheets: ref.watch(batchSetPillSheetsProvider),
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
    required List<PillSheetType?> pillSheetTypes,
    required PillSheetGroupDisplayNumberSetting? displayNumberSetting,
  }) async {
    final batch = batchFactory.batch();

    final n = now();
    final createdPillSheets = batchSetPillSheets(
      batch,
      pillSheetTypes.asMap().keys.map((pageIndex) {
        final pillSheetType = backportPillSheetTypes(pillSheetTypes)[pageIndex];
        final offset = summarizedPillCountWithPillSheetTypesToEndIndex(pillSheetTypes: setting.pillSheetEnumTypes, endIndex: pageIndex);
        return PillSheet(
          typeInfo: pillSheetType.typeInfo,
          beginingDate: n.add(
            Duration(days: offset),
          ),
          groupIndex: pageIndex,
        );
      }).toList(),
    );

    final pillSheetIDs = createdPillSheets.map((e) => e.id!).toList();
    final createdPillSheetGroup = batchSetPillSheetGroup(
      batch,
      PillSheetGroup(
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
      ),
    );

    final history = PillSheetModifiedHistoryServiceActionFactory.createCreatedPillSheetAction(
      pillSheetIDs: pillSheetIDs,
      pillSheetGroupID: createdPillSheetGroup.id,
    );
    batchSetPillSheetModifiedHistory(batch, history);

    batchSetSetting(
        batch,
        setting.copyWith(
          pillSheetTypes: pillSheetTypes,
        ));

    return batch.commit();
  }
}
