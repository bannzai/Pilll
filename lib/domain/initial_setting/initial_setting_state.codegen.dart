import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/util/datetime/day.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';

part 'initial_setting_state.codegen.freezed.dart';

@freezed
class InitialSettingTodayPillNumber with _$InitialSettingTodayPillNumber {
  const factory InitialSettingTodayPillNumber({
    @Default(0) int pageIndex,
    @Default(0) int pillNumberIntoPillSheet,
  }) = _InitialSettingTodayPillNumber;
}

@freezed
class InitialSettingState with _$InitialSettingState {
  const InitialSettingState._();
  const factory InitialSettingState({
    @Default([])
        List<PillSheetType> pillSheetTypes,
    InitialSettingTodayPillNumber? todayPillNumber,
    @Default([
      ReminderTime(hour: 20, minute: 0),
      ReminderTime(hour: 21, minute: 0),
    ])
        List<ReminderTime> reminderTimes,
    @Default(true)
        bool isOnReminder,
    @Default(false)
        bool isLoading,
    @Default(false)
        bool userIsNotAnonymous,
    @Default(false)
        bool settingIsExist,
    LinkAccountType? accountType,
  }) = _InitialSettingState;

  DateTime? reminderTimeOrDefault(int index) {
    if (index < reminderTimes.length) {
      return reminderDateTime(index);
    }
    final n = now();
    if (index == 0) {
      return DateTime(n.year, n.month, n.day, 20, 0, 0);
    }
    if (index == 1) {
      return DateTime(n.year, n.month, n.day, 21, 0, 0);
    }
    return null;
  }

  Setting buildSetting() {
    final menstruationDuration = 4;
    final maxPillCount = pillSheetTypes
        .map((e) => e.totalCount)
        .reduce((value, element) => value + element);
    final pillNumberForFromMenstruation = maxPillCount - menstruationDuration;

    final setting = Setting(
      pillNumberForFromMenstruation: pillNumberForFromMenstruation,
      durationMenstruation: menstruationDuration,
      pillSheetTypes: pillSheetTypes,
      reminderTimes: reminderTimes,
      isOnReminder: isOnReminder,
      pillSheetAppearanceMode: PillSheetAppearanceMode.number,
    );
    return setting;
  }

  static PillSheet buildPillSheet({
    required int pageIndex,
    required InitialSettingTodayPillNumber todayPillNumber,
    required List<PillSheetType> pillSheetTypes,
  }) {
    final pillSheetType = pillSheetTypes[pageIndex];
    return PillSheet(
      groupIndex: pageIndex,
      beginingDate: _beginingDate(
        pageIndex: pageIndex,
        todayPillNumber: todayPillNumber,
        pillSheetTypes: pillSheetTypes,
      ),
      lastTakenDate: _lastTakenDate(
        pageIndex: pageIndex,
        todayPillNumber: todayPillNumber,
        pillSheetTypes: pillSheetTypes,
      ),
      typeInfo: pillSheetType.typeInfo,
    );
  }

  static DateTime _beginingDate({
    required int pageIndex,
    required InitialSettingTodayPillNumber todayPillNumber,
    required List<PillSheetType> pillSheetTypes,
  }) {
    if (pageIndex <= todayPillNumber.pageIndex) {
      // Left side from todayPillNumber.pageIndex
      // Or current pageIndex == todayPillNumber.pageIndex
      final passedTotalCountElement = pillSheetTypes
          .sublist(0, todayPillNumber.pageIndex - pageIndex)
          .map((e) => e.totalCount);
      final int passedTotalCount;
      if (passedTotalCountElement.isEmpty) {
        passedTotalCount = 0;
      } else {
        passedTotalCount =
            passedTotalCountElement.reduce((value, element) => value + element);
      }

      return today().subtract(Duration(
          days: passedTotalCount +
              (todayPillNumber.pillNumberIntoPillSheet - 1)));
    } else {
      // Right Side from todayPillNumber.pageIndex
      final beforePillSheetBeginingDate = _beginingDate(
        pageIndex: pageIndex - 1,
        todayPillNumber: todayPillNumber,
        pillSheetTypes: pillSheetTypes,
      );
      final beforePillSheetType = pillSheetTypes[pageIndex - 1];
      return beforePillSheetBeginingDate
          .add(Duration(days: beforePillSheetType.totalCount));
    }
  }

  static DateTime? _lastTakenDate({
    required int pageIndex,
    required InitialSettingTodayPillNumber todayPillNumber,
    required List<PillSheetType> pillSheetTypes,
  }) {
    if (pageIndex == 0 &&
        todayPillNumber.pageIndex == 0 &&
        todayPillNumber.pillNumberIntoPillSheet == 1) {
      return null;
    }
    final pillSheetType = pillSheetTypes[pageIndex];
    if (todayPillNumber.pageIndex < pageIndex) {
      // Right side PillSheet
      return null;
    } else if (todayPillNumber.pageIndex > pageIndex) {
      // Left side PillSheet
      return _beginingDate(
        pageIndex: pageIndex,
        todayPillNumber: todayPillNumber,
        pillSheetTypes: pillSheetTypes,
      ).add(Duration(days: pillSheetType.totalCount - 1));
    } else {
      // Current PillSheet
      return _beginingDate(
        pageIndex: pageIndex,
        todayPillNumber: todayPillNumber,
        pillSheetTypes: pillSheetTypes,
      ).add(Duration(days: todayPillNumber.pillNumberIntoPillSheet - 2));
    }
  }

  DateTime reminderDateTime(int index) {
    var t = DateTime.now();
    final reminderTime = reminderTimes[index];
    return DateTime(t.year, t.month, t.day, reminderTime.hour,
        reminderTime.minute, t.second, t.millisecond, t.microsecond);
  }

  int? selectedTodayPillNumberIntoPillSheet({required int pageIndex}) {
    if (todayPillNumber?.pageIndex != pageIndex) {
      return null;
    }
    return todayPillNumber?.pillNumberIntoPillSheet;
  }
}
