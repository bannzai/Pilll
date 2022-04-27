import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:riverpod/riverpod.dart';

final settingDatabaseProvider =
    Provider((ref) => SettingDatabase(ref.watch(databaseProvider)));

class SettingDatabase {
  final DatabaseConnection _database;
  SettingDatabase(this._database);

  Future<Setting> fetch() {
    return _database.userReference().get().then((event) => Setting.fromJson(
        (event.data()
            as Map<String, dynamic>)[UserFirestoreFieldKeys.settings]));
  }

  Stream<Setting> stream() {
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

  void updateWithBatch(WriteBatch batch, Setting setting) {
    batch.set(
      _database.userReference(),
      {UserFirestoreFieldKeys.settings: setting.toJson()},
      SetOptions(merge: true),
    );
  }
}
