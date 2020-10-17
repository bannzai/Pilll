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
            InitialSettingModel.empty(
              fromMenstruation: null,
              durationMenstruation: null,
              reminderHour: null,
              reminderMinute: null,
              isOnReminder: false,
              todayPillNumber: null,
              pillSheetType: null,
            ),
          ),
        );
  InitialSettingInterface get _service => _read(initialSettingServiceProvider);

  void modify(InitialSettingModel Function(InitialSettingModel model) closure) {
    state = state.copyWith(entity: closure(state.entity));
  }

  void register(InitialSettingModel initialSetting) {
    _service.register(initialSetting);
  }
}
