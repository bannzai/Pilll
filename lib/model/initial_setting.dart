import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/user.dart' as user;
import 'package:Pilll/util/today.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InitialSettingModel extends ChangeNotifier {
  // User.Settings
  int fromMenstruation;
  int durationMenstruation;
  int reminderHour;
  int reminderMinute;
  bool isOnReminder = false;

  // User/{id}/PillSheet
  int todayPillNumber;

  // User.Settings & User/{id}/PillSheet
  PillSheetType pillSheetType;

  Map<String, dynamic> settingFirestoreRowData() {
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
    settings[SettingFirestoreFieldyKey.isOnReminder] = isOnReminder ?? false;
    if (pillSheetType != null)
      settings[SettingFirestoreFieldyKey.pillSheetTypeRawPath] =
          pillSheetType.name;
    return settings;
  }

  Map<String, dynamic> userPillSheetRowData() {
    var rowData = Map<String, dynamic>();
    if (pillSheetType != null) {
      rowData[PillSheetFirestoreFieldKey.pillSheetTypeInfo] = {
        PillSheetFirestoreFieldKey.pillSheetTypeInfoRef:
            pillSheetType.documentReference,
        PillSheetFirestoreFieldKey.pillSheetTypeInfoPillCount:
            pillSheetType.totalCount,
        PillSheetFirestoreFieldKey.pillSheetTypeInfoDosingPeriod:
            pillSheetType.dosingPeriod,
      };
      rowData[PillSheetFirestoreFieldKey.creator] = {
        PillSheetFirestoreFieldKey.creatorReference:
            user.User.user().documentReference(),
      };
      rowData[PillSheetFirestoreFieldKey.beginingDate] = Timestamp.fromDate(
          today().subtract(Duration(days: todayPillNumber - 1)));
      // NOTE: when user selected taken pill number is 1, treat as user not yet take pill in current pillsheet.
      rowData[PillSheetFirestoreFieldKey.lastTakenDate] =
          todayPillNumber == 1 ? null : Timestamp.fromDate(today());
    }
    return rowData;
  }

  Setting buildSetting() => Setting(settingFirestoreRowData());
  PillSheetModel buildPillSheet() => PillSheetModel(userPillSheetRowData());

  Future<InitialSettingModel> notifyWith(
      void update(InitialSettingModel model)) {
    update(this);
    notifyListeners();
    return Future.value(this);
  }
}
