import 'dart:async';

import 'package:pilll/entity/initial_setting.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/service/initial_setting.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/state/initial_setting.dart';
import 'package:riverpod/riverpod.dart';

final initialSettingStoreProvider = StateNotifierProvider(
  (ref) => InitialSettingStateStore(
    ref.watch(initialSettingServiceProvider),
    ref.watch(authServiceProvider),
    ref.watch(settingServiceProvider),
  ),
);

class InitialSettingStateStore extends StateNotifier<InitialSettingState> {
  final InitialSettingServiceInterface _service;
  final AuthService _authService;
  final SettingService _settingService;
  InitialSettingStateStore(
      this._service, this._authService, this._settingService)
      : super(
          InitialSettingState(
            entity: InitialSettingModel.initial(),
          ),
        ) {
    _reset();
  }

  _reset() {
    _subscribe();
  }

  StreamSubscription? _authCanceller;
  _subscribe() {
    _authCanceller?.cancel();
    _authCanceller = _authService.subscribe().listen((user) async {
      print(
          "watch sign state uid: ${user.uid}, isAnonymous: ${user.isAnonymous}");
      final isAccountCooperationDidEnd = !user.isAnonymous;
      if (isAccountCooperationDidEnd) {
        await callSignin();
      }
      state = state.copyWith(
          isAccountCooperationDidEnd: isAccountCooperationDidEnd);
    });
  }

  void selectedPillSheetType(PillSheetType pillSheetType) {
    state = state.copyWith(
        entity: state.entity.copyWith(pillSheetType: pillSheetType));
    if (state.entity.fromMenstruation > pillSheetType.totalCount) {
      state = state.copyWith(
          entity: state.entity
              .copyWith(fromMenstruation: pillSheetType.totalCount));
    }
  }

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

  Future<bool> canEndInitialSetting() async {
    try {
      await _settingService.fetch();
      return true;
    } catch (error) {
      return false;
    }
  }
}
