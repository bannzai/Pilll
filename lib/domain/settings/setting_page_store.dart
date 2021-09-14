import 'dart:async';

import 'package:pilll/database/batch.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
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

final settingStoreProvider = StateNotifierProvider(
  (ref) => SettingStateStore(
    ref.watch(batchFactoryProvider),
    ref.watch(settingServiceProvider),
    ref.watch(pillSheetServiceProvider),
    ref.watch(userServiceProvider),
    ref.watch(pillSheetModifiedHistoryServiceProvider),
    ref.watch(pillSheetGroupServiceProvider),
  ),
);

final settingStateProvider =
    Provider((ref) => ref.watch(settingStoreProvider.state));

class SettingStateStore extends StateNotifier<SettingState> {
  final BatchFactory _batchFactory;
  final SettingService _service;
  final PillSheetService _pillSheetService;
  final UserService _userService;
  final PillSheetModifiedHistoryService _pillSheetModifiedHistoryService;
  final PillSheetGroupService _pillSheetGroupService;
  SettingStateStore(
    this._batchFactory,
    this._service,
    this._pillSheetService,
    this._userService,
    this._pillSheetModifiedHistoryService,
    this._pillSheetGroupService,
  ) : super(SettingState(entity: null)) {
    _reset();
  }

  void _reset() {
    Future(() async {
      final storage = await SharedPreferences.getInstance();
      final userIsMigratedFrom132 =
          storage.containsKey(StringKey.salvagedOldStartTakenDate) &&
              storage.containsKey(StringKey.salvagedOldLastTakenDate);
      final entity = await _service.fetch();
      final pillSheetGroup = await _pillSheetGroupService.fetchLatest();
      final user = await _userService.fetch();
      this.state = SettingState(
        entity: entity,
        userIsUpdatedFrom132: userIsMigratedFrom132,
        latestPillSheetGroup: pillSheetGroup,
        isPremium: user.isPremium,
        isTrial: user.isTrial,
        trialDeadlineDate: user.trialDeadlineDate,
      );
      _subscribe();
    });
  }

  StreamSubscription? _canceller;
  StreamSubscription? _pillSheetGroupCanceller;
  StreamSubscription? _userSubscribeCanceller;
  void _subscribe() {
    _canceller?.cancel();
    _canceller = _service.subscribe().listen((event) {
      state = state.copyWith(entity: event);
    });
    _pillSheetGroupCanceller?.cancel();
    _pillSheetGroupCanceller =
        _pillSheetGroupService.subscribeForLatest().listen((event) {
      state = state.copyWith(latestPillSheetGroup: event);
    });
    _userSubscribeCanceller?.cancel();
    _userSubscribeCanceller = _userService.subscribe().listen((event) {
      state = state.copyWith(
        isPremium: event.isPremium,
        isTrial: event.isTrial,
        trialDeadlineDate: event.trialDeadlineDate,
      );
    });
  }

  @override
  void dispose() {
    _canceller?.cancel();
    _pillSheetGroupCanceller?.cancel();
    _userSubscribeCanceller?.cancel();
    super.dispose();
  }

  void _modifyReminderTimes(List<ReminderTime> reminderTimes) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("setting entity not found");
    }
    if (reminderTimes.length > ReminderTime.maximumCount) {
      throw Exception("登録できる上限に達しました。${ReminderTime.maximumCount}件以内に収めてください");
    }
    if (reminderTimes.length < ReminderTime.minimumCount) {
      throw Exception("通知時刻は最低${ReminderTime.minimumCount}件必要です");
    }
    _service
        .update(entity.copyWith(reminderTimes: reminderTimes))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void addReminderTimes(ReminderTime reminderTime) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("setting entity not found");
    }
    List<ReminderTime> copied = [...entity.reminderTimes];
    copied.add(reminderTime);
    _modifyReminderTimes(copied);
  }

  void editReminderTime(int index, ReminderTime reminderTime) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("setting entity not found");
    }
    List<ReminderTime> copied = [...entity.reminderTimes];
    copied[index] = reminderTime;
    _modifyReminderTimes(copied);
  }

  void deleteReminderTimes(int index) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("setting entity not found");
    }
    List<ReminderTime> copied = [...entity.reminderTimes];
    copied.removeAt(index);
    _modifyReminderTimes(copied);
  }

  Future<SettingState> modifyIsOnReminder(bool isOnReminder) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("setting entity not found");
    }
    return _service
        .update(entity.copyWith(isOnReminder: isOnReminder))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  Future<SettingState> modifyIsOnNotifyInNotTakenDuration(bool isOn) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("setting entity not found");
    }
    return _service
        .update(entity.copyWith(isOnNotifyInNotTakenDuration: isOn))
        .then((entity) => state = state.copyWith(entity: entity));
  }

  void update(Setting? entity) {
    state = state.copyWith(entity: entity);
  }

  Future<void> modifyBeginingDate({
    required int pageIndex,
    required int pillNumberIntoPillSheet,
  }) async {
    final pillSheetGroup = state.latestPillSheetGroup;
    if (pillSheetGroup == null) {
      throw FormatException("pill sheet group not found");
    }
    final activedPillSheet = pillSheetGroup.activedPillSheet;
    if (activedPillSheet == null) {
      throw FormatException("actived pill sheet not found");
    }
    final setting = state.entity;
    if (setting == null) {
      throw FormatException("setting entity not found");
    }

    final pillNumberIntoGroup = pastedTotalCount(
        pillSheetTypes: setting.pillSheetTypes, pageIndex: pageIndex) + pillNumberIntoPillSheet;
    final batch = _batchFactory.batch();
    final updated = modifyBeginingDateFunction(
      batch: batch,
      pillSheetService: _pillSheetService,
      pillSheetModifiedHistoryService: _pillSheetModifiedHistoryService,
      pillSheetGroupService: _pillSheetGroupService,
      pillSheetGroup: pillSheetGroup,
      pillNumberIntoGroup: pillNumberIntoGroup,
    );
    await batch.commit();

    state = state.copyWith(latestPillSheetGroup: updated);
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
            before: activedPillSheet, after: updatedPillSheet);
    _pillSheetModifiedHistoryService.add(batch, history);
    _pillSheetGroupService.delete(
        batch, pillSheetGroup.replaced(updatedPillSheet));

    return batch.commit();
  }

  Future<void> modifyPillSheetAppearanceMode(PillSheetAppearanceMode mode) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("setting entity not found");
    }
    final updated = entity.copyWith(pillSheetAppearanceMode: mode);
    return _service
        .update(updated)
        .then((value) => state = state.copyWith(entity: value));
  }

  Future<SettingState> modifiyIsAutomaticallyCreatePillSheet(bool isOn) {
    final entity = state.entity;
    if (entity == null) {
      throw FormatException("setting entity not found");
    }
    return _service
        .update(entity.copyWith(isAutomaticallyCreatePillSheet: isOn))
        .then((entity) => state = state.copyWith(entity: entity));
  }
}
