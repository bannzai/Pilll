import 'package:Pilll/state/initial_setting.dart';
import 'package:riverpod/all.dart';

final initialSettingStoreProvider =
    StateNotifierProvider((ref) => SettingStateStore(ref.read));

class SettingStateStore extends StateNotifier<InitialSettingState> {
  final Reader _read;
  SettingStateStore(this._read) : super(InitialSettingState()) {
    _reset();
  }

  void _reset() {
    Future(() async {
      state = SettingState(entity: await _read(userSettingProvider.future));
    });
  }

  void register(InitialSettingModel initialSetting) {
    _service
        .register(initialSetting)
        .then((entity) => state..copyWith(entity: entity));
  }
}
