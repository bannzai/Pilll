import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingFirestoreFieldyKey {
  static final String beginingMenstruationFromAfterFakePeriod =
      "beginingMenstruationFromAfterFakePeriod";
  static final String durationMenstruation = "durationMenstruation";
  static final String reminderTime = "reminderTime";
  static final String reminderTimeHour = "hour";
  static final String reminderTimeMinute = "minute";
  static final String isOnReminder = "isOnReminder";
  static final String pillSheetTypeRawPath = "pillSheetTypeRawPath";
}

class Setting extends ChangeNotifier {
  PillSheetType pillSheetType;
  int fromMenstruation;
  int durationMenstruation;
  int reminderHour;
  int reminderMinute;
  bool isOnReminder = false;

  factory Setting(Map<String, dynamic> rowData) {
    return Setting._(rowData);
  }
  Setting._(Map<String, dynamic> rowData) {
    if (rowData == null) {
      return;
    }
    this.fromMenstruation = rowData[
        SettingFirestoreFieldyKey.beginingMenstruationFromAfterFakePeriod];
    this.durationMenstruation =
        rowData[SettingFirestoreFieldyKey.durationMenstruation];
    this.reminderHour = rowData[SettingFirestoreFieldyKey.reminderTime]
        [SettingFirestoreFieldyKey.reminderTimeHour];
    this.reminderMinute = rowData[SettingFirestoreFieldyKey.reminderTime]
        [SettingFirestoreFieldyKey.reminderTimeMinute];
    this.isOnReminder = rowData[SettingFirestoreFieldyKey.isOnReminder];
    String pillSheetTypeRawPath =
        rowData[SettingFirestoreFieldyKey.pillSheetTypeRawPath];
    this.pillSheetType = pillSheetTypeRawPath == null
        ? null
        : PillSheetTypeFunctions.fromName(pillSheetTypeRawPath);
  }

  Map<String, dynamic> get settings {
    var settings = Map<String, dynamic>();
    if (fromMenstruation != null)
      settings[SettingFirestoreFieldyKey
          .beginingMenstruationFromAfterFakePeriod] = fromMenstruation;
    if (durationMenstruation != null)
      settings[SettingFirestoreFieldyKey.durationMenstruation] =
          durationMenstruation;
    if (reminderHour != null || reminderMinute != null)
      settings[SettingFirestoreFieldyKey.reminderTime] = {};
    if (reminderHour != null)
      settings[SettingFirestoreFieldyKey.reminderTime]
          [SettingFirestoreFieldyKey.reminderTimeHour] = reminderHour;
    if (reminderMinute != null)
      settings[SettingFirestoreFieldyKey.reminderTime]
          [SettingFirestoreFieldyKey.reminderTimeMinute] = reminderMinute;
    if (isOnReminder != null)
      settings[SettingFirestoreFieldyKey.isOnReminder] = isOnReminder;
    if (pillSheetType != null)
      settings[SettingFirestoreFieldyKey.pillSheetTypeRawPath] =
          pillSheetType.name;
    return settings;
  }

  Future<void> register() {
    return UserInterface.fetchOrCreateUser().then((value) {
      return save()
          .then((value) => null)
          .then((_) => SharedPreferences.getInstance())
          .then((storage) => storage.setString(
              StringKey.firebaseAnonymousUserID, value.anonymousUserID));
    });
  }

  Future<void> save() {
    return UserInterface.fetchOrCreateUser().then((value) {
      return value.updateSetting(this);
    });
  }

  Future<Setting> notifyWith(void update(Setting setting)) {
    update(this);
    notifyListeners();
    return Future.value(this);
  }

  DateTime reminderDateTime() {
    var t = DateTime.now().toLocal();
    return DateTime(t.year, t.month, t.day, reminderHour, reminderMinute,
        t.second, t.millisecond, t.microsecond);
  }
}
