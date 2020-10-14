import 'package:Pilll/model/initial_setting.dart';
import 'package:Pilll/state/initial_setting.dart';
import 'package:riverpod/all.dart';

final initialSettingStoreProvider =
    StateNotifierProvider((ref) => InitialSettingStateStore());

class InitialSettingStateStore extends StateNotifier<InitialSettingState> {
  InitialSettingStateStore()
      : super(InitialSettingState(
          InitialSettingModel.empty(
            fromMenstruation: null,
            durationMenstruation: null,
            reminderHour: null,
            reminderMinute: null,
            isOnReminder: false,
            todayPillNumber: null,
            pillSheetType: null,
          ),
        ));

  void modify(InitialSettingModel Function(InitialSettingModel model) closure) {
    state = state..copyWith(entity: closure(state.entity));
  }
}
