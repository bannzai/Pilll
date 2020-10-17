import 'package:Pilll/database/database.dart';
import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/provider/auth.dart';
import 'package:riverpod/all.dart';

abstract class InitialSettingInterface {
  Future<Setting> register(InitialSettingModel initialSetting);
}

final initialSettingServiceProvider =
    Provider((ref) => InitialSetting(ref.watch(databaseProvider)));

class InitialSetting extends InitialSettingInterface {
  final DatabaseConnection _database;
  InitialSetting(this._database);

  Future<Setting> register(InitialSettingModel initialSetting) {
    var setting = initialSetting.buildSetting();
    return _database
        .userReference()
        .update({UserFirestoreFieldKeys.settings: setting.toJson()}).then(
            (_) => setting);
  }
}
