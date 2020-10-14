import 'package:Pilll/database/database.dart';
import 'package:Pilll/initial_setting/initial_setting.dart';
import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/provider/auth.dart';
import 'package:riverpod/all.dart';

abstract class SettingServiceInterface {
  Future<Setting> register(InitialSettingModel initialSetting);
}

final settingServiceProvider = Provider((ref) => SettingService(ref.read));

class SettingService extends SettingServiceInterface {
  final Reader reader;
  SettingService(this.reader);

  DatabaseConnection get _database => reader(databaseProvider);

  Future<Setting> register(InitialSettingModel initialSetting) {
    if (AppState.shared.user.documentID == null) {
      throw UserNotFound();
    }
    var setting = initialSetting.buildSetting();
    return _database
        .userReference()
        .update({UserFirestoreFieldKeys.settings: setting.toJson()}).then(
            (_) => setting);
  }
}
