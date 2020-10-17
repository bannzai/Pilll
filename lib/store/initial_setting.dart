import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/service/initial_setting.dart';
import 'package:Pilll/state/initial_setting.dart';
import 'package:riverpod/all.dart';

final initialSettingStoreProvider =
    StateNotifierProvider((ref) => InitialSettingStateStore(ref.read));

class InitialSettingStateStore extends StateNotifier<InitialSettingState> {
  final Reader _read;
  InitialSettingStateStore(this._read)
      : super(
          InitialSettingState(
            InitialSettingModel.initial(),
          ),
        );
  InitialSettingInterface get _service => _read(initialSettingServiceProvider);

  void modify(InitialSettingModel Function(InitialSettingModel model) closure) {
    state = state.copyWith(entity: closure(state.entity));
  }

  Future<void> register(InitialSettingModel initialSetting) {
    return _service.register(initialSetting);
  }
}
