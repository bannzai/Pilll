import 'package:pilll/database/batch.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/service/setting.dart';
import 'package:riverpod/riverpod.dart';

final initialSettingServiceProvider = Provider<InitialSettingService>(
  (ref) => InitialSettingService(
    ref.watch(batchFactoryProvider),
    ref.watch(settingServiceProvider),
    ref.watch(pillSheetServiceProvider),
    ref.watch(pillSheetModifiedHistoryServiceProvider),
    ref.watch(pillSheetGroupServiceProvider),
  ),
);

class InitialSettingService {
  final BatchFactory batchFactory;
  final SettingService settingService;
  final PillSheetService pillSheetService;
  final PillSheetModifiedHistoryService pillSheetModifiedHistoryService;
  final PillSheetGroupService pillSheetGroupService;

  InitialSettingService(
    this.batchFactory,
    this.settingService,
    this.pillSheetService,
    this.pillSheetModifiedHistoryService,
    this.pillSheetGroupService,
  );

  Future<void> register(Setting setting, PillSheet? pillSheet) {
    return settingService.update(setting).then((_) {
      if (pillSheet == null) {
        return Future.value();
      }
      final batch = batchFactory.batch();
      final updatedPillSheet = pillSheetService.register(batch, pillSheet);

      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: [updatedPillSheet.id!],
        pillSheets: [updatedPillSheet],
      );
      pillSheetGroupService.register(batch, pillSheetGroup);

      final history = PillSheetModifiedHistoryServiceActionFactory
          .createCreatedPillSheetAction(
        pillSheetGroupID: pillSheetGroup.id,
        pillSheetIDs: pillSheetGroup.pillSheetIDs,
      );
      pillSheetModifiedHistoryService.add(batch, history);

      return batch.commit();
    });
  }
}
