import 'dart:async';

import 'package:Pilll/entity/pill_sheet_type.dart';
import 'package:Pilll/entity/setting.dart';
import 'package:Pilll/entity/user_error.dart';
import 'package:Pilll/service/setting.dart';
import 'package:Pilll/state/setting.dart';
import 'package:riverpod/riverpod.dart';

final settingStoreProvider = StateNotifierProvider(
    (ref) => SettingStateStore(ref.watch(settingServiceProvider)));

class SettingStateStore extends StateNotifier<SettingState> {
  final SettingServiceInterface _service;
  SettingStateStore(this._service) : super(SettingState()) {
    _reset();
  }

  void _reset() {
    _service
        .fetch()
        .then((entity) => SettingState(entity: entity))
        .then((state) => this.state = state)
        .then((_) => _subscribe());
  }

  StreamSubscription canceller;
  void _subscribe() {
    canceller?.cancel();
    canceller = _service.subscribe().listen((event) {
      assert(event != null, "Setting could not null on subscribe");
      if (event == null) return;
      state = SettingState(entity: event);
    });
  }

  @override
  void dispose() {
    canceller?.cancel();
    super.dispose();
  }

  void modifyType(PillSheetType pillSheetType) {
    _service
        .update(
            state.entity.copyWith(pillSheetTypeRawPath: pillSheetType.rawPath))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void _modifyReminderTimes(List<ReminderTime> reminderTimes) {
    if (reminderTimes.length > ReminderTime.maximumCount) {
      throw UserDisplayedError(
          displayedMessage:
              "登録できる上限に達しました。${ReminderTime.maximumCount}件以内に収めてください");
    }
    if (reminderTimes.length < ReminderTime.minimumCount) {
      throw UserDisplayedError(
          displayedMessage: "通知時刻は最低${ReminderTime.minimumCount}件必要です");
    }
    _service
        .update(state.entity.copyWith(reminderTimes: reminderTimes))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void addReminderTimes(ReminderTime reminderTime) {
    List<ReminderTime> copied = [...state.entity.reminderTimes];
    copied.add(reminderTime);
    _modifyReminderTimes(copied);
  }

  void editReminderTime(int index, ReminderTime reminderTime) {
    List<ReminderTime> copied = [...state.entity.reminderTimes];
    copied[index] = reminderTime;
    _modifyReminderTimes(copied);
  }

  void deleteReminderTimes(int index) {
    List<ReminderTime> copied = [...state.entity.reminderTimes];
    copied.removeAt(index);
    _modifyReminderTimes(copied);
  }

  void modifyIsOnReminder(bool isOnReminder) {
    _service
        .update(state.entity.copyWith(isOnReminder: isOnReminder))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void modifyFromMenstruation(int fromMenstruation) {
    _service
        .update(state.entity.copyWith(fromMenstruation: fromMenstruation))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void modifyDurationMenstruation(int durationMenstruation) {
    _service
        .update(
            state.entity.copyWith(durationMenstruation: durationMenstruation))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void update(Setting entity) {
    state = state.copyWith(entity: entity);
  }
}
