import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pilll/provider/database.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:riverpod/riverpod.dart';

final settingProvider = StreamProvider<Setting>(
    (ref) => ref.watch(databaseProvider).userReference().snapshots().map((event) => event.data()?.setting).where((data) => data != null).cast());

final setSettingProvider = Provider((ref) => SetSetting(ref.watch(databaseProvider)));

class SetSetting {
  final DatabaseConnection databaseConnection;
  SetSetting(this.databaseConnection);

  Future<void> call(Setting setting) async {
    await databaseConnection.userRawReference().set({UserFirestoreFieldKeys.settings: setting}, SetOptions(merge: true));
  }
}

final batchSetSettingProvider = Provider((ref) => BatchSetSetting(ref.watch(databaseProvider)));

class BatchSetSetting {
  final DatabaseConnection databaseConnection;
  BatchSetSetting(this.databaseConnection);

  void call(WriteBatch batch, Setting setting) {
    batch.set(
      databaseConnection.userRawReference(),
      {UserFirestoreFieldKeys.settings: setting.toJson()},
      SetOptions(merge: true),
    );
  }
}
