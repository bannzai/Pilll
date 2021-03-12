import 'dart:async';

import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/state/setting.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingStoreProvider = StateNotifierProvider(
    (ref) => SettingStateStore(ref.watch(settingServiceProvider)));

class SettingStateStore extends StateNotifier<SettingState> {
  final SettingServiceInterface _service;
  SettingStateStore(this._service) : super(SettingState()) {
    _reset();
  }

  void _reset() {
    Future(() async {
      final storage = await SharedPreferences.getInstance();
      final userIsMigratedFrom132 =
          storage.containsKey(StringKey.salvagedOldStartTakenDate) &&
              storage.containsKey(StringKey.salvagedOldLastTakenDate);
      final entity = await _service.fetch();
      this.state = SettingState(
          entity: entity, userIsUpdatedFrom132: userIsMigratedFrom132);
      _subscribe();
    });
  }

  StreamSubscription? canceller;
  void _subscribe() {
    canceller?.cancel();
    canceller = _service.subscribe().listen((event) {
      assert(event != null, "Setting could not null on subscribe");
      if (event == null) return;
      state = SettingState(
          entity: event, userIsUpdatedFrom132: state.userIsUpdatedFrom132);
    });
  }

  @override
  void dispose() {
    canceller?.cancel();
    super.dispose();
  }

  Future<void> modifyType(PillSheetType pillSheetType) {
    return _service
        .update(
            state.entity?.copyWith(pillSheetTypeRawPath: pillSheetType.rawPath))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void _modifyReminderTimes(List<ReminderTime> reminderTimes) {
    if (reminderTimes.length > ReminderTime.maximumCount) {
      throw Exception("登録できる上限に達しました。${ReminderTime.maximumCount}件以内に収めてください");
    }
    if (reminderTimes.length < ReminderTime.minimumCount) {
      throw Exception("通知時刻は最低${ReminderTime.minimumCount}件必要です");
    }
    _service
        .update(state.entity?.copyWith(reminderTimes: reminderTimes))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void addReminderTimes(ReminderTime reminderTime) {
    List<ReminderTime> copied = [...state.entity?.reminderTimes];
    copied.add(reminderTime);
    _modifyReminderTimes(copied);
  }

  void editReminderTime(int index, ReminderTime reminderTime) {
    List<ReminderTime> copied = [...state.entity?.reminderTimes];
    copied[index] = reminderTime;
    _modifyReminderTimes(copied);
  }

  void deleteReminderTimes(int index) {
    List<ReminderTime> copied = [...state.entity?.reminderTimes];
    copied.removeAt(index);
    _modifyReminderTimes(copied);
  }

  Future<SettingState> modifyIsOnReminder(bool isOnReminder) {
    return _service
        .update(state.entity?.copyWith(isOnReminder: isOnReminder))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  Future<SettingState> modifyIsOnNotifyInNotTakenDuration(bool isOn) {
    return _service
        .update(state.entity?.copyWith(isOnNotifyInNotTakenDuration: isOn))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  Future<void> modifyFromMenstruation(int fromMenstruation) {
    return _service
        .update(state.entity?
            .copyWith(pillNumberForFromMenstruation: fromMenstruation))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  Future<void> modifyDurationMenstruation(int durationMenstruation) {
    return _service
        .update(
            state.entity?.copyWith(durationMenstruation: durationMenstruation))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void update(Setting? entity) {
    state = state.copyWith(entity: entity);
  }
}
