import 'package:Pilll/model/user.dart';
import 'package:Pilll/service/setting.dart';
import 'package:Pilll/state/setting.dart';
import 'package:riverpod/riverpod.dart';

final settingStoreProvider =
    StateNotifierProvider((ref) => SettingStateStore(ref.read));

class SettingStateStore extends StateNotifier<SettingState> {
  final Reader _read;
  SettingServiceInterface get _service => _read(settingServiceProvider);
  SettingStateStore(this._read) : super(SettingState()) {
    _reset();
  }

  void _reset() {
    Future(() async {
      state = SettingState(entity: await _read(userSettingProvider.future));
    });
  }
}
