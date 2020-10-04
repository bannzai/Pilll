import 'package:Pilll/main/components/pill/pill_mark.dart';
import 'package:Pilll/model/app_state+user.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:Pilll/util/today.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialSettingModel {
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
        isOnReminder: isOnReminder,
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

  Future<void> register() {
    return UserInterface.fetchOrCreateUser().then((value) {
      return this
          .buildSetting()
          .save()
          .then((value) => null)
          .then((_) => SharedPreferences.getInstance())
          .then((storage) => storage.setString(
              StringKey.firebaseAnonymousUserID, value.anonymousUserID));
    });
  }

  PillMarkType pillMarkTypeFor(int number) {
    assert(pillSheetType != null);
    if (todayPillNumber == number) {
      return PillMarkType.selected;
    }
    if (pillSheetType.beginingWithoutTakenPeriod <= number) {
      return PillMarkType.notTaken;
    }
    return PillMarkType.normal;
  }

  DateTime reminderDateTime() {
    var t = DateTime.now().toLocal();
    return DateTime(t.year, t.month, t.day, reminderHour, reminderMinute,
        t.second, t.millisecond, t.microsecond);
  }
}
