import 'package:Pilll/model/app_state.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class SettingRepositoryInterface {
  Future<Setting> save(Setting setting);
}

class SettingRepository extends SettingRepositoryInterface {
  Future<Setting> save(Setting setting) {
    if (AppState.shared.user.documentID == null) {
      throw UserNotFound();
    }
    return FirebaseFirestore.instance
        .collection(User.path)
        .doc(AppState.shared.user.documentID)
        .update({UserFirestoreFieldKeys.settings: setting.toJson()}).then(
            (_) => setting);
  }
}

final SettingRepositoryInterface settingRepository = SettingRepository();
