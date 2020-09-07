import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingKey {
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
  int hour;
  int minute;
  bool isOnReminder = false;

  factory Setting(Map<String, dynamic> rowData) {
    return Setting._(rowData);
  }
  Setting._(Map<String, dynamic> rowData) {
    if (rowData == null) {
      return;
    }
    this.fromMenstruation =
        rowData[SettingKey.beginingMenstruationFromAfterFakePeriod];
    this.durationMenstruation = rowData[SettingKey.durationMenstruation];
    this.hour = rowData[SettingKey.reminderTime][SettingKey.reminderTimeHour];
    this.minute =
        rowData[SettingKey.reminderTime][SettingKey.reminderTimeMinute];
    this.isOnReminder = rowData[SettingKey.isOnReminder];
    String pillSheetTypeRawPath = rowData[SettingKey.pillSheetTypeRawPath];
    this.pillSheetType = pillSheetTypeRawPath == null
        ? null
        : PillSheetTypeFunctions.fromName(pillSheetTypeRawPath);
  }

  Map<String, dynamic> get settings {
    var settings = Map<String, dynamic>();
    if (fromMenstruation != null)
      settings[SettingKey.beginingMenstruationFromAfterFakePeriod] =
          fromMenstruation;
    if (durationMenstruation != null)
      settings[SettingKey.durationMenstruation] = durationMenstruation;
    if (hour != null || minute != null) settings[SettingKey.reminderTime] = {};
    if (hour != null)
      settings[SettingKey.reminderTime][SettingKey.reminderTimeHour] = hour;
    if (minute != null)
      settings[SettingKey.reminderTime][SettingKey.reminderTimeMinute] = minute;
    if (isOnReminder != null) settings[SettingKey.isOnReminder] = isOnReminder;
    if (pillSheetType != null)
      settings[SettingKey.pillSheetTypeRawPath] = pillSheetType.name;
    return settings;
  }

  Future<void> register() {
    return UserInterface.fetchOrCreateUser().then((value) {
      save()
          .then((value) => null)
          .then((_) => SharedPreferences.getInstance())
          .then((storage) => storage.setString(
              StringKey.firebaseAnonymousUserID, value.anonymousUserID));
    });
  }

  Future<void> save() {
    return UserInterface.fetchOrCreateUser().then((value) {
      value.updateSetting(this);
    });
  }

  Future<Setting> notifyWith(void update(Setting setting)) {
    update(this);
    notifyListeners();
    return Future.value(this);
  }
}
