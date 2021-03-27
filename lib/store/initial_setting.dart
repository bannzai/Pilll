import 'package:pilll/entity/initial_setting.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/service/initial_setting.dart';
import 'package:pilll/state/initial_setting.dart';
import 'package:riverpod/riverpod.dart';

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

  void setReminderTime(int index, int hour, int minute) {
    final copied = [...state.entity.reminderTimes];
    if (index >= copied.length) {
      copied.add(ReminderTime(hour: hour, minute: minute));
    } else {
      copied[index] = ReminderTime(hour: hour, minute: minute);
    }
    modify((model) => model.copyWith(reminderTimes: copied));
  }

  Future<void> register(InitialSettingModel initialSetting) {
    return _service.register(initialSetting);
  }
}
