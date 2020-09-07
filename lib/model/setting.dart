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
  bool isOnReminder;

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
      settings["beginingMenstruationFromAfterFakePeriod"] = fromMenstruation;
    if (durationMenstruation != null)
      settings["menstuationPeriod"] = fromMenstruation;
    if (hour != null || minute != null) settings["reminderTime"] = {};
    if (hour != null) settings["reminderTime"]["hour"] = hour;
    if (minute != null) settings["reminderTime"]["minute"] = minute;
    if (isOnReminder != null) settings["isOnReminder"] = isOnReminder;
    if (pillSheetType != null)
      settings["pillSheetTypeRawPath"] = pillSheetType.name;
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

  void notifyWith(void update(Setting setting)) {
    update(this);
    notifyListeners();
  }
}
