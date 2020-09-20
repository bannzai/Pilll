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
  bool isOnReminder;

  factory Setting(Map<String, dynamic> firestoreRowData) {
    assert(firestoreRowData != null);
    String pillSheetTypeRawPath =
        firestoreRowData[SettingFirestoreFieldyKey.pillSheetTypeRawPath];
    return Setting._(
      pillSheetType: pillSheetTypeRawPath == null
          ? null
          : PillSheetTypeFunctions.fromName(pillSheetTypeRawPath),
      fromMenstruation: firestoreRowData[
          SettingFirestoreFieldyKey.beginingMenstruationFromAfterFakePeriod],
      durationMenstruation:
          firestoreRowData[SettingFirestoreFieldyKey.durationMenstruation],
      reminderHour: firestoreRowData[SettingFirestoreFieldyKey.reminderTime]
          [SettingFirestoreFieldyKey.reminderTimeHour],
      reminderMinute: firestoreRowData[SettingFirestoreFieldyKey.reminderTime]
          [SettingFirestoreFieldyKey.reminderTimeMinute],
      isOnReminder:
          firestoreRowData[SettingFirestoreFieldyKey.isOnReminder] ?? false,
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
        SettingFirestoreFieldyKey.beginingMenstruationFromAfterFakePeriod];
    this.durationMenstruation =
        firestoreRowData[SettingFirestoreFieldyKey.durationMenstruation];
    this.reminderHour = firestoreRowData[SettingFirestoreFieldyKey.reminderTime]
        [SettingFirestoreFieldyKey.reminderTimeHour];
    this.reminderMinute =
        firestoreRowData[SettingFirestoreFieldyKey.reminderTime]
            [SettingFirestoreFieldyKey.reminderTimeMinute];
    this.isOnReminder =
        firestoreRowData[SettingFirestoreFieldyKey.isOnReminder];
    String pillSheetTypeRawPath =
        firestoreRowData[SettingFirestoreFieldyKey.pillSheetTypeRawPath];
    this.pillSheetType = pillSheetTypeRawPath == null
        ? null
        : PillSheetTypeFunctions.fromName(pillSheetTypeRawPath);
  }

  Map<String, dynamic> get firestoreRowData {
    var rowData = Map<String, dynamic>();
    if (fromMenstruation != null)
      rowData[SettingFirestoreFieldyKey
          .beginingMenstruationFromAfterFakePeriod] = fromMenstruation;
    if (durationMenstruation != null)
      rowData[SettingFirestoreFieldyKey.durationMenstruation] =
          durationMenstruation;
    if (reminderHour != null || reminderMinute != null)
      rowData[SettingFirestoreFieldyKey.reminderTime] = {};
    if (reminderHour != null)
      rowData[SettingFirestoreFieldyKey.reminderTime]
          [SettingFirestoreFieldyKey.reminderTimeHour] = reminderHour;
    if (reminderMinute != null)
      rowData[SettingFirestoreFieldyKey.reminderTime]
          [SettingFirestoreFieldyKey.reminderTimeMinute] = reminderMinute;
    rowData[SettingFirestoreFieldyKey.isOnReminder] = isOnReminder ?? false;
    if (pillSheetType != null)
      rowData[SettingFirestoreFieldyKey.pillSheetTypeRawPath] =
          pillSheetType.name;
    return rowData;
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
