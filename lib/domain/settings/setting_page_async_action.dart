import 'dart:async';
import 'dart:io';

import 'package:pilll/database/batch.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/native/health_care.dart';
import 'package:pilll/database/pill_sheet.dart';
import 'package:pilll/database/pill_sheet_group.dart';
import 'package:pilll/database/pill_sheet_modified_history.dart';
import 'package:pilll/database/setting.dart';
import 'package:pilll/domain/settings/setting_page_state.codegen.dart';
import 'package:pilll/database/user.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingPageAsyncActionProvider = Provider(
  (ref) => SettingPageAsyncAction(
    ref.watch(batchFactoryProvider),
    ref.watch(settingDatastoreProvider),
    ref.watch(pillSheetDatastoreProvider),
    ref.watch(userDatastoreProvider),
    ref.watch(pillSheetModifiedHistoryDatastoreProvider),
    ref.watch(pillSheetGroupDatastoreProvider),
  ),
);

class SettingPageAsyncAction {
  final BatchFactory _batchFactory;
  final SettingDatastore _settingDatastore;
  final PillSheetDatastore _pillSheetDatastore;
  final UserDatastore _userDatastore;
  final PillSheetModifiedHistoryDatastore _pillSheetModifiedHistoryDatastore;
  final PillSheetGroupDatastore _pillSheetGroupDatastore;

  SettingPageAsyncAction(
    this._batchFactory,
    this._settingDatastore,
    this._pillSheetDatastore,
    this._userDatastore,
    this._pillSheetModifiedHistoryDatastore,
    this._pillSheetGroupDatastore,
  );

  Future<void> _modifyReminderTimes({
    required Setting setting,
    required List<ReminderTime> reminderTimes,
  }) async {
    if (reminderTimes.length > ReminderTime.maximumCount) {
      throw Exception("登録できる上限に達しました。${ReminderTime.maximumCount}件以内に収めてください");
    }
    if (reminderTimes.length < ReminderTime.minimumCount) {
      throw Exception("通知時刻は最低${ReminderTime.minimumCount}件必要です");
    }
    await _settingDatastore
        .update(setting.copyWith(reminderTimes: reminderTimes));
  }

  Future<void> addReminderTimes({
    required Setting setting,
    required ReminderTime reminderTime,
  }) async {
    List<ReminderTime> copied = [...setting.reminderTimes];
    copied.add(reminderTime);
    await _modifyReminderTimes(reminderTimes: copied, setting: setting);
  }

  Future<void> editReminderTime({
    required int index,
    required Setting setting,
    required ReminderTime reminderTime,
  }) async {
    List<ReminderTime> copied = [...setting.reminderTimes];
    copied[index] = reminderTime;
    await _modifyReminderTimes(reminderTimes: copied, setting: setting);
  }

  Future<void> deleteReminderTimes({
    required int index,
    required Setting setting,
  }) async {
    List<ReminderTime> copied = [...setting.reminderTimes];
    copied.removeAt(index);
    await _modifyReminderTimes(reminderTimes: copied, setting: setting);
  }

  Future<void> modifyIsOnReminder(bool isOnReminder, Setting setting) async {
    await _settingDatastore
        .update(setting.copyWith(isOnReminder: isOnReminder));
  }

  Future<void> modifyIsOnNotifyInNotTakenDuration(
      bool isOn, Setting setting) async {
    await _settingDatastore
        .update(setting.copyWith(isOnNotifyInNotTakenDuration: isOn));
  }

  Future<void> deletePillSheet({
    required PillSheetGroup latestPillSheetGroup,
    required PillSheet activedPillSheet,
  }) async {
    final batch = _batchFactory.batch();
    final updatedPillSheet =
        _pillSheetDatastore.delete(batch, activedPillSheet);
    final history = PillSheetModifiedHistoryServiceActionFactory
        .createDeletedPillSheetAction(
      pillSheetGroupID: latestPillSheetGroup.id,
      pillSheetIDs: latestPillSheetGroup.pillSheetIDs,
    );
    _pillSheetModifiedHistoryDatastore.add(batch, history);
    _pillSheetGroupDatastore.delete(
        batch, latestPillSheetGroup.replaced(updatedPillSheet));

    return batch.commit();
  }

  Future<void> modifiyIsAutomaticallyCreatePillSheet(
      bool isOn, Setting setting) async {
    await _settingDatastore
        .update(setting.copyWith(isAutomaticallyCreatePillSheet: isOn));
  }

  Future<void> reminderNotificationWordSubmit(
      String word, Setting setting) async {
    var reminderNotificationCustomization =
        setting.reminderNotificationCustomization;
    reminderNotificationCustomization =
        reminderNotificationCustomization.copyWith(word: word);

    await _settingDatastore.update(setting.copyWith(
        reminderNotificationCustomization: reminderNotificationCustomization));
  }

  Future<void> setIsInVisibleReminderDate(
      bool isInVisibleReminderDate, Setting setting) async {
    var reminderNotificationCustomization =
        setting.reminderNotificationCustomization;
    reminderNotificationCustomization = reminderNotificationCustomization
        .copyWith(isInVisibleReminderDate: isInVisibleReminderDate);

    await _settingDatastore.update(setting.copyWith(
        reminderNotificationCustomization: reminderNotificationCustomization));
  }

  Future<void> setIsInVisiblePillNumber(
      bool isInVisiblePillNumber, Setting setting) async {
    var reminderNotificationCustomization =
        setting.reminderNotificationCustomization;
    reminderNotificationCustomization = reminderNotificationCustomization
        .copyWith(isInVisiblePillNumber: isInVisiblePillNumber);

    await _settingDatastore.update(setting.copyWith(
        reminderNotificationCustomization: reminderNotificationCustomization));
  }

  Future<void> setIsInVisibleDescription(
      bool isInVisibleDescription, Setting setting) async {
    var reminderNotificationCustomization =
        setting.reminderNotificationCustomization;
    reminderNotificationCustomization = reminderNotificationCustomization
        .copyWith(isInVisibleDescription: isInVisibleDescription);

    await _settingDatastore.update(setting.copyWith(
        reminderNotificationCustomization: reminderNotificationCustomization));
  }
}
