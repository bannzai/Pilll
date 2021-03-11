import 'package:Pilll/entity/initial_setting.dart';
import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/service/setting.dart';
import 'package:riverpod/riverpod.dart';

abstract class InitialSettingServiceInterface {
  Future<void> register(InitialSettingModel initialSetting) {
    throw new UnimplementedError("Should call subclass");
  }
}

final initialSettingServiceProvider = Provider<InitialSettingServiceInterface>(
    (ref) => InitialSettingService(ref.watch(settingServiceProvider),
        ref.watch(pillSheetServiceProvider)));

class InitialSettingService extends InitialSettingServiceInterface {
  final SettingServiceInterface settingService;
  final PillSheetServiceInterface pillSheetService;

  InitialSettingService(this.settingService, this.pillSheetService);

  Future<void> register(InitialSettingModel initialSetting) {
    var setting = initialSetting.buildSetting();
    return settingService.update(setting).then((_) {
      final pillSheet = initialSetting.buildPillSheet();
      if (pillSheet == null) {
        return Future.value();
      }
      return pillSheetService.register(pillSheet);
    });
  }
}
