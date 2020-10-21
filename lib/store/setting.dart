import 'dart:async';

import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/user_error.dart';
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
      _subscribe();
    });
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
          error: null,
          displayedMessage:
              "登録できる上限に達しました。${ReminderTime.maximumCount}件以内に収めてください");
    }
    if (reminderTimes.length < ReminderTime.minimumCount) {
      throw UserDisplayedError(
          error: null,
          displayedMessage: "通知時刻は最低${ReminderTime.minimumCount}件必要です");
    }
    _service
        .update(state.entity.copyWith(reminderTimes: reminderTimes))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void addReminderTimes(ReminderTime reminderTime) {
    _modifyReminderTimes(state.entity.reminderTimes..add(reminderTime));
  }

  void editReminderTime(int index, ReminderTime reminderTime) {
    _modifyReminderTimes(state.entity.reminderTimes..[index] = reminderTime);
  }

  void deleteReminderTimes(int index) {
    _modifyReminderTimes(state.entity.reminderTimes..remove(index));
  }

  void deleteReminderTimesImmediately(int index) {
    state = state.copyWith(
      entity: state.entity.copyWith(
        reminderTimes: state.entity.reminderTimes..remove(index),
      ),
    );
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
