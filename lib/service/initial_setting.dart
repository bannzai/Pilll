import 'package:pilll/database/database.dart';
import 'package:pilll/entity/initial_setting.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/setting.dart';
import 'package:riverpod/riverpod.dart';

abstract class InitialSettingServiceInterface {
  Future<void> register(InitialSettingModel initialSetting) {
    throw new UnimplementedError("Should call subclass");
  }
}

final initialSettingServiceProvider = Provider<InitialSettingServiceInterface>(
  (ref) => InitialSettingService(
    ref.watch(databaseProvider),
    ref.watch(settingServiceProvider),
    ref.watch(pillSheetServiceProvider),
  ),
);

class InitialSettingService extends InitialSettingServiceInterface {
  final DatabaseConnection database;
  final SettingService settingService;
  final PillSheetService pillSheetService;

  InitialSettingService(
      this.database, this.settingService, this.pillSheetService);

  Future<void> register(InitialSettingModel initialSetting) {
    var setting = initialSetting.buildSetting();
    return settingService.update(setting).then((_) {
      final pillSheet = initialSetting.buildPillSheet();
      if (pillSheet == null) {
        return Future.value();
      }
      return pillSheetService.register(database.batch(), pillSheet);
    });
  }
}
