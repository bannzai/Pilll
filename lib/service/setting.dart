import 'dart:async';

import 'package:pilll/database/database.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/user.dart';
import 'package:pilll/service/user.dart';
import 'package:riverpod/riverpod.dart';

abstract class SettingServiceInterface {
  Future<Setting> fetch();
  Future<Setting> update(Setting setting);
  Stream<Setting> subscribe();
}

final settingServiceProvider =
    Provider((ref) => SettingService(ref.watch(databaseProvider as AlwaysAliveProviderBase<Object?, DatabaseConnection>)));

// ignore: top_level_function_literal_block
final userSettingProvider = FutureProvider((ref) async {
  final user = await ref.watch(initialUserProvider.future);
  return user.setting;
});

class SettingService extends SettingServiceInterface {
  final DatabaseConnection _database;
  SettingService(this._database);

  Future<Setting> fetch() {
    return _database.userReference().get().then((event) =>
        Setting.fromJson(event.data()![UserFirestoreFieldKeys.settings]));
  }

  Stream<Setting> subscribe() {
    return _database
        .userReference()
        .snapshots()
        .map((event) =>
            Setting.fromJson(event.data()![UserFirestoreFieldKeys.settings]))
        .where((event) => event != null);
  }

  Future<Setting> update(Setting setting) {
    return _database
        .userReference()
        .update({UserFirestoreFieldKeys.settings: setting.toJson()}).then(
            (_) => setting);
  }
}
