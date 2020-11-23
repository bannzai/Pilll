import 'package:Pilll/entity/initial_setting.dart';
import 'package:Pilll/service/pill_sheet.dart';
import 'package:Pilll/service/setting.dart';
import 'package:riverpod/all.dart';

abstract class InitialSettingInterface {
  Future<void> register(InitialSettingModel initialSetting) async {
    throw new UnimplementedError("Should call subclass");
  }
}

final initialSettingServiceProvider = Provider((ref) => InitialSettingPage(
    ref.watch(settingServiceProvider), ref.watch(pillSheetServiceProvider)));

class InitialSettingPage extends InitialSettingInterface {
  final SettingServiceInterface settingService;
  final PillSheetServiceInterface pillSheetService;

  InitialSettingPage(this.settingService, this.pillSheetService);

  Future<void> register(InitialSettingModel initialSetting) async {
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
