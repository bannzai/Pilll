import 'package:Pilll/model/pill_sheet_type.dart';

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

class Setting {
  PillSheetType pillSheetType;
  int fromMenstruation;
  int durationMenstruation;
  int hour;
  int minute;
  bool isOnReminder;

  Setting(Map<String, dynamic> rowData) {
    fromMenstruation =
        rowData[SettingKey.beginingMenstruationFromAfterFakePeriod];
    durationMenstruation = rowData[SettingKey.durationMenstruation];
    hour = rowData[SettingKey.reminderTime][SettingKey.reminderTimeHour];
    minute = rowData[SettingKey.reminderTime][SettingKey.reminderTimeMinute];
    isOnReminder = rowData[SettingKey.isOnReminder];
    String pillSheetTypeRawPath = rowData[SettingKey.pillSheetTypeRawPath];
    pillSheetType = pillSheetTypeRawPath == null
        ? null
        : PillSheetTypeFunctions.fromName(pillSheetTypeRawPath);
  }

  Map<String, dynamic> get settings {
    var settings = Map<String, dynamic>();
    if (fromMenstruation != null)
      settings["beginingMenstruationFromAfterFakePeriod"] = fromMenstruation;
    if (durationMenstruation != null)
      settings["menstuationPeriod"] = fromMenstruation;
    settings["reminderTime"] = {};
    if (hour != null) settings["reminderTime"]["hour"] = hour;
    if (minute != null) settings["reminderTime"]["minute"] = minute;
    if (isOnReminder != null) settings["isOnReminder"] = isOnReminder;
    if (pillSheetType != null)
      settings["pillSheetTypeRawPath"] = pillSheetType.name;
    return settings;
  }
}
