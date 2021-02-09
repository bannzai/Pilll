import 'package:Pilll/entity/pill_mark_type.dart';
import 'package:Pilll/entity/pill_sheet.dart';
import 'package:Pilll/entity/pill_sheet_type.dart';
import 'package:Pilll/entity/setting.dart';
import 'package:Pilll/util/datetime/day.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'initial_setting.freezed.dart';

@freezed
abstract class InitialSettingModel implements _$InitialSettingModel {
  InitialSettingModel._();
  factory InitialSettingModel.initial({
    @Default(2)
        int fromMenstruation,
    @Default(4)
        int durationMenstruation,
    @Default([
      ReminderTime(hour: 21, minute: 0),
      ReminderTime(hour: 22, minute: 0),
    ])
        List<ReminderTime> reminderTimes,
    @Default(false)
        bool isOnReminder,
    int todayPillNumber,
    PillSheetType pillSheetType,
  }) = _InitialSettingModel;

  Setting buildSetting() => Setting(
        fromMenstruation: fromMenstruation,
        durationMenstruation: durationMenstruation,
        pillSheetTypeRawPath: pillSheetType.rawPath,
        reminderTimes: reminderTimes,
        isOnReminder: isOnReminder,
      );
  PillSheetModel buildPillSheet() => todayPillNumber != null
      ? PillSheetModel(
          beginingDate: _beginingDate(),
          lastTakenDate: _lastTakenDate(),
          typeInfo: _typeInfo(),
        )
      : null;

  DateTime _beginingDate() {
    return today().subtract(Duration(days: todayPillNumber - 1));
  }

  DateTime _lastTakenDate() {
    return todayPillNumber == 1 ? null : today().subtract(Duration(days: 1));
  }

  PillSheetTypeInfo _typeInfo() {
    return PillSheetTypeInfo(
      pillSheetTypeReferencePath: pillSheetType.rawPath,
      name: pillSheetType.fullName,
      dosingPeriod: pillSheetType.dosingPeriod,
      totalCount: pillSheetType.totalCount,
    );
  }

  PillMarkType pillMarkTypeFor(int number) {
    assert(pillSheetType != null);
    if (todayPillNumber == number) {
      return PillMarkType.selected;
    }
    if (pillSheetType.beginingWithoutTakenPeriod <= number) {
      return pillSheetType == PillSheetType.pillsheet_21
          ? PillMarkType.rest
          : PillMarkType.fake;
    }
    return PillMarkType.normal;
  }

  DateTime reminderDateTime(int index) {
    var t = DateTime.now();
    final reminderTime = reminderTimes[index];
    return DateTime(t.year, t.month, t.day, reminderTime.hour,
        reminderTime.minute, t.second, t.millisecond, t.microsecond);
  }
}
