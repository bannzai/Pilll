import 'package:Pilll/initial_setting/initial_setting.dart';
import 'package:Pilll/model/pill_mark_type.dart';
import 'package:Pilll/model/pill_sheet.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:Pilll/util/today.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'initial_setting.freezed.dart';

@freezed
abstract class InitialSettingModel implements _$InitialSettingModel {
  InitialSettingModel._();
  factory InitialSettingModel({
    int fromMenstruation,
    int durationMenstruation,
    int reminderHour,
    int reminderMinute,
    @Default(false) bool isOnReminder,
    int todayPillNumber,
    PillSheetType pillSheetType,
  }) = _InitialSettingModel;

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
    return userRepository.fetchOrCreateUser().then((value) {
      var setting = this.buildSetting();
      return settingRepository
          .register(setting)
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
