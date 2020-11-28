import 'package:Pilll/entity/initial_setting.dart';
import 'package:Pilll/service/initial_setting.dart';
import 'package:Pilll/state/initial_setting.dart';
import 'package:riverpod/all.dart';

final initialSettingStoreProvider = StateNotifierProvider((ref) =>
    InitialSettingStateStore(ref.watch(initialSettingServiceProvider)));

class InitialSettingStateStore extends StateNotifier<InitialSettingState> {
  final InitialSettingServiceInterface _service;
  InitialSettingStateStore(this._service)
      : super(
          InitialSettingState(
            InitialSettingModel.initial(),
          ),
        );

  void modify(InitialSettingModel Function(InitialSettingModel model) closure) {
    state = state.copyWith(entity: closure(state.entity));
  }

  Future<void> register(InitialSettingModel initialSetting) {
    return _service.register(initialSetting);
  }
}
