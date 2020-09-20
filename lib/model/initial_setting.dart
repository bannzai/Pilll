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
      settings[SettingFirestoreFieldyKeys
          .beginingMenstruationFromAfterFakePeriod] = fromMenstruation;
    if (durationMenstruation != null)
      settings[SettingFirestoreFieldyKeys.durationMenstruation] =
          durationMenstruation;
    if (reminderHour != null || reminderMinute != null)
      settings[SettingFirestoreFieldyKeys.reminderTime] = {};
    if (reminderHour != null)
      settings[SettingFirestoreFieldyKeys.reminderTime]
          [SettingFirestoreFieldyKeys.reminderTimeHour] = reminderHour;
    if (reminderMinute != null)
      settings[SettingFirestoreFieldyKeys.reminderTime]
          [SettingFirestoreFieldyKeys.reminderTimeMinute] = reminderMinute;
    settings[SettingFirestoreFieldyKeys.isOnReminder] = isOnReminder ?? false;
    if (pillSheetType != null)
      settings[SettingFirestoreFieldyKeys.pillSheetTypeRawPath] =
          pillSheetType.name;
    return settings;
  }

  Map<String, dynamic> userPillSheetRowData() {
    var rowData = Map<String, dynamic>();
    if (pillSheetType != null) {
      rowData[PillSheetFirestoreFieldKeys.pillSheetTypeInfo] = {
        PillSheetFirestoreFieldKeys.pillSheetTypeInfoRef:
            pillSheetType.documentReference,
        PillSheetFirestoreFieldKeys.pillSheetTypeInfoPillCount:
            pillSheetType.totalCount,
        PillSheetFirestoreFieldKeys.pillSheetTypeInfoDosingPeriod:
            pillSheetType.dosingPeriod,
      };
      rowData[PillSheetFirestoreFieldKeys.creator] = {
        PillSheetFirestoreFieldKeys.creatorReference:
            user.User.user().documentReference(),
      };
      rowData[PillSheetFirestoreFieldKeys.beginingDate] = Timestamp.fromDate(
          today().subtract(Duration(days: todayPillNumber - 1)));
      // NOTE: when user selected taken pill number is 1, treat as user not yet take pill in current pillsheet.
      rowData[PillSheetFirestoreFieldKeys.lastTakenDate] =
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
