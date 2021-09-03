import 'package:pilll/database/batch.dart';
import 'package:pilll/entity/initial_setting.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/service/setting.dart';
import 'package:riverpod/riverpod.dart';

abstract class InitialSettingServiceInterface {
  Future<void> register(InitialSettingModel initialSetting) {
    throw new UnimplementedError("Should call subclass");
  }
}

final initialSettingServiceProvider = Provider<InitialSettingServiceInterface>(
  (ref) => InitialSettingService(
    ref.watch(batchFactoryProvider),
    ref.watch(settingServiceProvider),
    ref.watch(pillSheetServiceProvider),
    ref.watch(pillSheetModifiedHistoryServiceProvider),
    ref.watch(pillSheetGroupServiceProvider),
  ),
);

class InitialSettingService extends InitialSettingServiceInterface {
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

  Future<void> register(InitialSettingModel initialSetting) {
    var setting = initialSetting.buildSetting();
    return settingService.update(setting).then((_) {
      final pillSheet = initialSetting.buildPillSheet();
      if (pillSheet == null) {
        return Future.value();
      }
      final batch = batchFactory.batch();
      final updatedPillSheet = pillSheetService.register(batch, pillSheet);
      final history = PillSheetModifiedHistoryServiceActionFactory
          .createCreatedPillSheetAction(
              before: null,
              pillSheetID: updatedPillSheet.id!,
              after: pillSheet);
      pillSheetModifiedHistoryService.add(batch, history);

      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: [updatedPillSheet.id!],
        pillSheets: [updatedPillSheet],
      );
      pillSheetGroupService.register(batch, pillSheetGroup);

      return batch.commit();
    });
  }
}
