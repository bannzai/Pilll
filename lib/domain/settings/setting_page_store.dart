import 'dart:async';

import 'package:pilll/database/batch.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/pill_sheet_group.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/domain/settings/setting_page_state.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingStoreProvider =
    StateNotifierProvider<SettingStateStore, SettingState>(
  (ref) => SettingStateStore(
    ref.watch(batchFactoryProvider),
    ref.watch(settingServiceProvider),
    ref.watch(pillSheetServiceProvider),
    ref.watch(userServiceProvider),
    ref.watch(pillSheetModifiedHistoryServiceProvider),
    ref.watch(pillSheetGroupServiceProvider),
  ),
);

final settingStateProvider = Provider((ref) => ref.watch(settingStoreProvider));

class SettingStateStore extends StateNotifier<SettingState> {
  final BatchFactory _batchFactory;
  final SettingService _settingService;
  final PillSheetService _pillSheetService;
  final UserService _userService;
  final PillSheetModifiedHistoryService _pillSheetModifiedHistoryService;
  final PillSheetGroupService _pillSheetGroupService;
  SettingStateStore(
    this._batchFactory,
    this._settingService,
    this._pillSheetService,
    this._userService,
    this._pillSheetModifiedHistoryService,
    this._pillSheetGroupService,
  ) : super(SettingState(setting: null)) {
    reset();
  }

  void reset() async {
    try {
      state = state.copyWith(exception: null);
      final storage = await SharedPreferences.getInstance();
      final userIsMigratedFrom132 =
          storage.containsKey(StringKey.salvagedOldStartTakenDate) &&
              storage.containsKey(StringKey.salvagedOldLastTakenDate);
      final setting = await _settingService.fetch();
      final pillSheetGroup = await _pillSheetGroupService.fetchLatest();
      final user = await _userService.fetch();
      this.state = SettingState(
        setting: setting,
        userIsUpdatedFrom132: userIsMigratedFrom132,
        latestPillSheetGroup: pillSheetGroup,
        isPremium: user.isPremium,
        isTrial: user.isTrial,
        trialDeadlineDate: user.trialDeadlineDate,
      );
      _subscribe();
    } catch (exception) {
      state = state.copyWith(exception: exception);
    }
  }

  StreamSubscription? _settingCanceller;
  StreamSubscription? _pillSheetGroupCanceller;
  StreamSubscription? _userSubscribeCanceller;
  void _subscribe() {
    _settingCanceller?.cancel();
    _settingCanceller = _settingService.stream().listen((event) {
      state = state.copyWith(setting: event);
    });
    _pillSheetGroupCanceller?.cancel();
    _pillSheetGroupCanceller =
        _pillSheetGroupService.streamForLatest().listen((event) {
      state = state.copyWith(latestPillSheetGroup: event);
    });
    _userSubscribeCanceller?.cancel();
    _userSubscribeCanceller = _userService.stream().listen((event) {
      state = state.copyWith(
        isPremium: event.isPremium,
        isTrial: event.isTrial,
        trialDeadlineDate: event.trialDeadlineDate,
      );
    });
  }

  @override
  void dispose() {
    _settingCanceller?.cancel();
    _pillSheetGroupCanceller?.cancel();
    _userSubscribeCanceller?.cancel();
    super.dispose();
  }

  void _modifyReminderTimes(List<ReminderTime> reminderTimes) {
    final setting = state.setting;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }
    if (reminderTimes.length > ReminderTime.maximumCount) {
      throw Exception("登録できる上限に達しました。${ReminderTime.maximumCount}件以内に収めてください");
    }
    if (reminderTimes.length < ReminderTime.minimumCount) {
      throw Exception("通知時刻は最低${ReminderTime.minimumCount}件必要です");
    }
    _settingService
        .update(setting.copyWith(reminderTimes: reminderTimes))
        .then((entity) => state = state.copyWith(setting: entity));
  }

  void addReminderTimes(ReminderTime reminderTime) {
    final setting = state.setting;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }
    List<ReminderTime> copied = [...setting.reminderTimes];
    copied.add(reminderTime);
    _modifyReminderTimes(copied);
  }

  void editReminderTime(int index, ReminderTime reminderTime) {
    final setting = state.setting;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }
    List<ReminderTime> copied = [...setting.reminderTimes];
    copied[index] = reminderTime;
    _modifyReminderTimes(copied);
  }

  void deleteReminderTimes(int index) {
    final setting = state.setting;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }
    List<ReminderTime> copied = [...setting.reminderTimes];
    copied.removeAt(index);
    _modifyReminderTimes(copied);
  }

  Future<SettingState> modifyIsOnReminder(bool isOnReminder) {
    final setting = state.setting;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }
    return _settingService
        .update(setting.copyWith(isOnReminder: isOnReminder))
        .then((setting) => state = state.copyWith(setting: setting));
  }

  Future<SettingState> modifyIsOnNotifyInNotTakenDuration(bool isOn) {
    final setting = state.setting;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }
    return _settingService
        .update(setting.copyWith(isOnNotifyInNotTakenDuration: isOn))
        .then((setting) => state = state.copyWith(setting: setting));
  }

  void update(Setting? setting) {
    state = state.copyWith(setting: setting);
  }

  Future<void> deletePillSheet() {
    final pillSheetGroup = state.latestPillSheetGroup;
    if (pillSheetGroup == null) {
      throw FormatException("pill sheet group not found");
    }
    final activedPillSheet = pillSheetGroup.activedPillSheet;
    if (activedPillSheet == null) {
      throw FormatException("actived pill sheet not found");
    }

    final batch = _batchFactory.batch();
    final updatedPillSheet = _pillSheetService.delete(batch, activedPillSheet);
    final history = PillSheetModifiedHistoryServiceActionFactory
        .createDeletedPillSheetAction(
      pillSheetGroupID: pillSheetGroup.id,
      pillSheetIDs: pillSheetGroup.pillSheetIDs,
    );
    _pillSheetModifiedHistoryService.add(batch, history);
    _pillSheetGroupService.delete(
        batch, pillSheetGroup.replaced(updatedPillSheet));

    return batch.commit();
  }

  Future<SettingState> modifiyIsAutomaticallyCreatePillSheet(bool isOn) {
    final setting = state.setting;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }
    return _settingService
        .update(setting.copyWith(isAutomaticallyCreatePillSheet: isOn))
        .then((setting) => state = state.copyWith(setting: setting));
  }

  Future<void> reminderNotificationWordSubmit(String word) {
    final setting = state.setting;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }

    var reminderNotificationCustomization =
        setting.reminderNotificationCustomization;
    reminderNotificationCustomization =
        reminderNotificationCustomization.copyWith(word: word);

    return _settingService
        .update(setting.copyWith(
            reminderNotificationCustomization:
                reminderNotificationCustomization))
        .then((setting) => state = state.copyWith(setting: setting));
  }

  Future<void> setIsInVisibleReminderDate(bool isInVisibleReminderDate) {
    final setting = state.setting;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }

    var reminderNotificationCustomization =
        setting.reminderNotificationCustomization;
    reminderNotificationCustomization = reminderNotificationCustomization
        .copyWith(isInVisibleReminderDate: isInVisibleReminderDate);

    return _settingService
        .update(setting.copyWith(
            reminderNotificationCustomization:
                reminderNotificationCustomization))
        .then((setting) => state = state.copyWith(setting: setting));
  }

  Future<void> setIsInVisiblePillNumber(bool isInVisiblePillNumber) {
    final setting = state.setting;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }

    var reminderNotificationCustomization =
        setting.reminderNotificationCustomization;
    reminderNotificationCustomization = reminderNotificationCustomization
        .copyWith(isInVisiblePillNumber: isInVisiblePillNumber);

    return _settingService
        .update(setting.copyWith(
            reminderNotificationCustomization:
                reminderNotificationCustomization))
        .then((setting) => state = state.copyWith(setting: setting));
  }

  Future<void> setIsInVisibleDescription(bool isInVisibleDescription) {
    final setting = state.setting;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }

    var reminderNotificationCustomization =
        setting.reminderNotificationCustomization;
    reminderNotificationCustomization = reminderNotificationCustomization
        .copyWith(isInVisibleDescription: isInVisibleDescription);

    return _settingService
        .update(setting.copyWith(
            reminderNotificationCustomization:
                reminderNotificationCustomization))
        .then((setting) => state = state.copyWith(setting: setting));
  }
}
