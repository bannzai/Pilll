import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/user.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingFirestoreFieldyKeys {
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
  bool isOnReminder;

  factory Setting(Map<String, dynamic> firestoreRowData) {
    assert(firestoreRowData != null);
    String pillSheetTypeRawPath =
        firestoreRowData[SettingFirestoreFieldyKeys.pillSheetTypeRawPath];
    return Setting._(
      pillSheetType: pillSheetTypeRawPath == null
          ? null
          : PillSheetTypeFunctions.fromName(pillSheetTypeRawPath),
      fromMenstruation: firestoreRowData[
          SettingFirestoreFieldyKeys.beginingMenstruationFromAfterFakePeriod],
      durationMenstruation:
          firestoreRowData[SettingFirestoreFieldyKeys.durationMenstruation],
      reminderHour: firestoreRowData[SettingFirestoreFieldyKeys.reminderTime]
          [SettingFirestoreFieldyKeys.reminderTimeHour],
      reminderMinute: firestoreRowData[SettingFirestoreFieldyKeys.reminderTime]
          [SettingFirestoreFieldyKeys.reminderTimeMinute],
      isOnReminder:
          firestoreRowData[SettingFirestoreFieldyKeys.isOnReminder] ?? false,
    );
  }
  Setting._({
    @required this.pillSheetType,
    @required this.fromMenstruation,
    @required this.durationMenstruation,
    @required this.reminderHour,
    @required this.reminderMinute,
    @required this.isOnReminder,
  }) {
    assert(isOnReminder != null);
    this.fromMenstruation = firestoreRowData[
        SettingFirestoreFieldyKeys.beginingMenstruationFromAfterFakePeriod];
    this.durationMenstruation =
        firestoreRowData[SettingFirestoreFieldyKeys.durationMenstruation];
    this.reminderHour =
        firestoreRowData[SettingFirestoreFieldyKeys.reminderTime]
            [SettingFirestoreFieldyKeys.reminderTimeHour];
    this.reminderMinute =
        firestoreRowData[SettingFirestoreFieldyKeys.reminderTime]
            [SettingFirestoreFieldyKeys.reminderTimeMinute];
    this.isOnReminder =
        firestoreRowData[SettingFirestoreFieldyKeys.isOnReminder];
    String pillSheetTypeRawPath =
        firestoreRowData[SettingFirestoreFieldyKeys.pillSheetTypeRawPath];
    this.pillSheetType = pillSheetTypeRawPath == null
        ? null
        : PillSheetTypeFunctions.fromName(pillSheetTypeRawPath);
  }

  Map<String, dynamic> get firestoreRowData {
    var rowData = Map<String, dynamic>();
    if (fromMenstruation != null)
      rowData[SettingFirestoreFieldyKeys
          .beginingMenstruationFromAfterFakePeriod] = fromMenstruation;
    if (durationMenstruation != null)
      rowData[SettingFirestoreFieldyKeys.durationMenstruation] =
          durationMenstruation;
    if (reminderHour != null || reminderMinute != null)
      rowData[SettingFirestoreFieldyKeys.reminderTime] = {};
    if (reminderHour != null)
      rowData[SettingFirestoreFieldyKeys.reminderTime]
          [SettingFirestoreFieldyKeys.reminderTimeHour] = reminderHour;
    if (reminderMinute != null)
      rowData[SettingFirestoreFieldyKeys.reminderTime]
          [SettingFirestoreFieldyKeys.reminderTimeMinute] = reminderMinute;
    rowData[SettingFirestoreFieldyKeys.isOnReminder] = isOnReminder ?? false;
    if (pillSheetType != null)
      rowData[SettingFirestoreFieldyKeys.pillSheetTypeRawPath] =
          pillSheetType.name;
    return rowData;
  }

  Future<void> save() {
    return User.fetch().then((value) {
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
