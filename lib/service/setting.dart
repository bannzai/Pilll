import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/entity/user.dart';
import 'package:riverpod/riverpod.dart';

final settingServiceProvider =
    Provider((ref) => SettingService(ref.watch(databaseProvider)));

class SettingService {
  final DatabaseConnection _database;
  SettingService(this._database);

  Future<Setting> fetch() {
    return _database.userReference().get().then((event) => Setting.fromJson(
        (event.data()
            as Map<String, dynamic>)[UserFirestoreFieldKeys.settings]));
  }

  Stream<Setting> subscribe() {
    return _database
        .userReference()
        .snapshots()
        .map((event) => event.data())
        .where((data) => data != null)
        .map((data) => Setting.fromJson(
            (data as Map<String, dynamic>)[UserFirestoreFieldKeys.settings]))
        .cast();
  }

  Future<Setting> update(Setting setting) {
    return _database
        .userReference()
        .update({UserFirestoreFieldKeys.settings: setting.toJson()}).then(
            (_) => setting);
  }

  updateWithBatch(WriteBatch batch, Setting setting) {
    batch.set(
      _database.userReference(),
      {UserFirestoreFieldKeys.settings: setting.toJson()},
      SetOptions(merge: true),
    );
    return setting;
  }
}
