import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/user.dart';
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
      state = SettingState(await _read(userSettingProvider.future));
    });
  }

  void modifyType(PillSheetType pillSheetType) {
    _service
        .update(
            state.entity.copyWith(pillSheetTypeRawPath: pillSheetType.rawPath))
        .then((entity) => state = state..copyWith(entity: entity));
  }

  void modifyReminderTime(ReminderTime reminderTime) {
    _service
        .update(state.entity.copyWith(reminderTime: reminderTime))
        .then((entity) => state = state..copyWith(entity: entity));
  }

  void modifyIsOnReminder(bool isOnReminder) {
    _service
        .update(state.entity.copyWith(isOnReminder: isOnReminder))
        .then((entity) => state = state..copyWith(entity: entity));
  }

  void modifyFromMenstruation(int fromMenstruation) {
    _service
        .update(state.entity.copyWith(fromMenstruation: fromMenstruation))
        .then((entity) => state = state..copyWith(entity: entity));
  }

  void modifyDurationMenstruation(int durationMenstruation) {
    _service
        .update(
            state.entity.copyWith(durationMenstruation: durationMenstruation))
        .then((entity) => state = state..copyWith(entity: entity));
  }

  void update(Setting entity) {
    state = state..copyWith(entity: entity);
  }
}
