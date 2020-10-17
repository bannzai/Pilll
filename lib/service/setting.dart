import 'package:Pilll/database/database.dart';
import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/provider/auth.dart';
import 'package:riverpod/all.dart';

abstract class SettingServiceInterface {
  Future<Setting> register(InitialSettingModel initialSetting);
  Future<Setting> update(Setting setting);
}

final settingServiceProvider =
    Provider((ref) => SettingService(ref.watch(databaseProvider)));

class SettingService extends SettingServiceInterface {
  final DatabaseConnection _database;
  SettingService(this._database);

  Future<Setting> register(InitialSettingModel initialSetting) {
    var setting = initialSetting.buildSetting();
    return _database
        .userReference()
        .update({UserFirestoreFieldKeys.settings: setting.toJson()}).then(
            (_) => setting);
  }

  Future<Setting> update(Setting setting) {
    return _database
        .userReference()
        .update({UserFirestoreFieldKeys.settings: setting.toJson()}).then(
            (_) => setting);
  }
}
