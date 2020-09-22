import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/model/user.dart' as user;
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:Pilll/util/today.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Setting buildSetting() => Setting(
        fromMenstruation: fromMenstruation,
        durationMenstruation: durationMenstruation,
        pillSheetTypeRawPath: pillSheetType.rawPath,
        reminderTime: ReminderTime(hour: reminderHour, minute: reminderMinute),
      );
  PillSheetModel buildPillSheet() => PillSheetModel(
        beginingDate: _beginingDate(),
        lastTakenDate: _lastTakenDate(),
        typeInfo: _typeInfo(),
      );

  DateTime _beginingDate() {
    return today().subtract(Duration(days: todayPillNumber - 1));
  }

  DateTime _lastTakenDate() {
    return todayPillNumber == 1 ? null : today();
  }

  PillSheetTypeInfo _typeInfo() {
    return PillSheetTypeInfo(
      pillSheetTypeReferencePath: pillSheetType.rawPath,
      dosingPeriod: pillSheetType.dosingPeriod,
      totalCount: pillSheetType.totalCount,
    );
  }

  Future<InitialSettingModel> notifyWith(
      void update(InitialSettingModel model)) {
    update(this);
    notifyListeners();
    return Future.value(this);
  }

  Future<void> register() {
    return user.User.fetch().then((value) {
      return this
          .buildSetting()
          .save()
          .then((value) => null)
          .then((_) => SharedPreferences.getInstance())
          .then((storage) => storage.setString(
              StringKey.firebaseAnonymousUserID, value.anonymousUserID));
    });
  }
}
