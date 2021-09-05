import 'package:pilll/util/datetime/day.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_mark_type.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';

part 'initial_setting_state.freezed.dart';

@freezed
abstract class InitialSettingState implements _$InitialSettingState {
  InitialSettingState._();
  factory InitialSettingState({
    @Default(23)
        int fromMenstruation,
    @Default(4)
        int durationMenstruation,
    @Default([
      ReminderTime(hour: 21, minute: 0),
      ReminderTime(hour: 22, minute: 0),
    ])
        List<ReminderTime> reminderTimes,
    @Default(true)
        bool isOnReminder,
    int? todayPillNumber,
    PillSheetType? pillSheetType,
    @Default(1)
        int pillSheetCount,
    @Default(false)
        bool isLoading,
    @Default(false)
        bool isAccountCooperationDidEnd,
    @Default(false)
        isOnSequenceAppearance,
  }) = _InitialSettingState;

  DateTime? reminderTimeOrDefault(int index) {
    if (index < reminderTimes.length) {
      return reminderDateTime(index);
    }
    final n = now();
    if (index == 0) {
      return DateTime(n.year, n.month, n.day, 21, 0, 0);
    }
    if (index == 1) {
      return DateTime(n.year, n.month, n.day, 22, 0, 0);
    }
    return null;
  }

  Setting buildSetting() => Setting(
        pillNumberForFromMenstruation: fromMenstruation,
        durationMenstruation: durationMenstruation,
        pillSheetTypeRawPath: pillSheetType!.rawPath,
        reminderTimes: reminderTimes,
        isOnReminder: isOnReminder,
      );

  PillSheet buildPillSheet({
    required int pageIndex,
    required int todayPillNumber,
    required PillSheetType pillSheetType,
  }) {
    return PillSheet(
      groupIndex: pageIndex,
      beginingDate: _beginingDate(
        pageIndex: pageIndex,
        todayPillNumber: todayPillNumber,
        pillSheetType: pillSheetType,
      ),
      lastTakenDate: _lastTakenDate(
        pageIndex: pageIndex,
        todayPillNumber: todayPillNumber,
        pillSheetType: pillSheetType,
      ),
      typeInfo: _typeInfo(),
    );
  }

  DateTime _beginingDate({
    required int pageIndex,
    required int todayPillNumber,
    required PillSheetType pillSheetType,
  }) {
    final pageOffset = pageIndex * pillSheetType.totalCount;
    return today().subtract(Duration(days: todayPillNumber - 1 + pageOffset));
  }

  DateTime? _lastTakenDate({
    required int pageIndex,
    required int todayPillNumber,
    required PillSheetType pillSheetType,
  }) {
    if (pageIndex == 0 && todayPillNumber == 1) {
      return null;
    }
    final pillSheetBeginPillNumber = pageIndex * pillSheetType.totalCount + 1;
    final pillSheetEndPillNumber =
        pageIndex * pillSheetType.totalCount + pillSheetType.totalCount;
    if (pillSheetBeginPillNumber <= todayPillNumber &&
        todayPillNumber <= pillSheetEndPillNumber) {
      // Between current PillSheet
      return today().subtract(Duration(days: 1));
    } else if (todayPillNumber < pillSheetEndPillNumber) {
      // Right side PillSheet
      return null;
    } else {
      // Left side PillSheet
      return _beginingDate(
        pageIndex: pageIndex,
        todayPillNumber: todayPillNumber,
        pillSheetType: pillSheetType,
      ).add(Duration(days: pillSheetType.totalCount - 1));
    }
  }

  PillSheetTypeInfo _typeInfo() {
    return PillSheetTypeInfo(
      pillSheetTypeReferencePath: pillSheetType!.rawPath,
      name: pillSheetType!.fullName,
      dosingPeriod: pillSheetType!.dosingPeriod,
      totalCount: pillSheetType!.totalCount,
    );
  }

  PillMarkType pillMarkTypeFor(int number) {
    final pillSheetType = this.pillSheetType;
    if (pillSheetType == null) {
      throw ArgumentError.notNull("pill sheet type not allowed null");
    }
    if (todayPillNumber == number) {
      return PillMarkType.selected;
    }
    if (pillSheetType.dosingPeriod < number) {
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
