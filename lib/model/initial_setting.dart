import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/user.dart' as user;
import 'package:Pilll/util/today.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InitialSetting extends ChangeNotifier {
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
    if (isOnReminder != null)
      settings[SettingFirestoreFieldyKey.isOnReminder] = isOnReminder;
    if (pillSheetType != null)
      settings[SettingFirestoreFieldyKey.pillSheetTypeRawPath] =
          pillSheetType.name;
    return settings;
  }

  Map<String, dynamic> userPillSheetRowData() {
    var rowData = Map<String, dynamic>();
    if (pillSheetType != null) {
      DocumentReference pillSheetTypeReference = FirebaseFirestore.instance
          .collection(PillSheetTypeFunctions.firestoreCollectionPath)
          .doc(pillSheetType.firestorePath);
      rowData[PillSheetFirestoreFieldKey.pillSheetTypeInfo] = {
        PillSheetFirestoreFieldKey.pillSheetTypeInfoRef: pillSheetTypeReference,
        PillSheetFirestoreFieldKey.pillSheetTypeInfoPillCount:
            pillSheetType.totalCount,
        PillSheetFirestoreFieldKey.pillSheetTypeInfoDosingPeriod:
            pillSheetType.dosingPeriod,
      };
      rowData[PillSheetFirestoreFieldKey.creator] = {
        PillSheetFirestoreFieldKey.creatorReference: user.User.userReference,
      };
      rowData[PillSheetFirestoreFieldKey.beginingDate] = Timestamp.fromDate(
          today().subtract(Duration(days: todayPillNumber - 1)));
    }
    return rowData;
  }
}

abstract class PillSheetFirestoreFieldKey {
  static final String creator = "creator";
  static final String creatorReference = "reference";
  static final String beginingDate = "beginingDate";
  static final String pillSheetTypeInfo = "pillSheetTypeInfo";
  static final String pillSheetTypeInfoRef = "reference";
  static final String pillSheetTypeInfoPillCount = "pillCount";
  static final String pillSheetTypeInfoDosingPeriod = "dosingPeriod";
  static final String lastTakenDate = "lastTakenDate";
}
