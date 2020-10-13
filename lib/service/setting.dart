import 'package:Pilll/database/database.dart';
import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/provider/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/all.dart';

abstract class SettingServiceInterface {
  Future<Setting> save(Setting setting);
}

class SettingService extends SettingServiceInterface {
  final Reader reader;
  SettingService(this.reader);

  DatabaseConnection get _database => reader(databaseProvider);

  Future<Setting> save(Setting setting) {
    if (AppState.shared.user.documentID == null) {
      throw UserNotFound();
    }
    return _database
        .userReference()
        .update({UserFirestoreFieldKeys.settings: setting.toJson()}).then(
            (_) => setting);
  }
}

SettingServiceInterface settingRepository = SettingService(null);
