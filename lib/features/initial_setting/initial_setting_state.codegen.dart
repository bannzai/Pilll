import 'dart:math';

import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/utils/datetime/date_add.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.codegen.dart';

part 'initial_setting_state.codegen.freezed.dart';

@freezed
class InitialSettingTodayPillNumber with _$InitialSettingTodayPillNumber {
  const factory InitialSettingTodayPillNumber({
    @Default(0) int pageIndex,
    @Default(0) int pillNumberInPillSheet,
  }) = _InitialSettingTodayPillNumber;
}

@freezed
class InitialSettingState with _$InitialSettingState {
  const InitialSettingState._();
  const factory InitialSettingState({
    @Default([]) List<PillSheetType> pillSheetTypes,
    InitialSettingTodayPillNumber? todayPillNumber,
    required List<ReminderTime> reminderTimes,
    @Default(true) bool isOnReminder,
    @Default(false) bool isLoading,
    @Default(false) bool settingIsExist,
    LinkAccountType? accountType,
  }) = _InitialSettingState;

  DateTime? reminderTimeOrNull(int index) {
    if (index < reminderTimes.length) {
      return reminderDateTime(index);
    }
    final n = now();
    if (index == 0) {
      return DateTime(n.year, n.month, n.day, n.hour, 0, 0);
    }
    if (index == 1) {
      return DateTime(n.year, n.month, n.day, n.hour + 1, 0, 0);
    }
    return null;
  }

  Future<Setting> buildSetting() async {
    const menstruationDuration = 4;
    final maxPillCount = pillSheetTypes.map((e) => e.totalCount).fold(0, (previousValue, element) => previousValue + element);
    final pillNumberForFromMenstruation = max(0, maxPillCount - menstruationDuration);

    final setting = Setting(
      pillNumberForFromMenstruation: pillNumberForFromMenstruation,
      durationMenstruation: menstruationDuration,
      pillSheetTypes: pillSheetTypes,
      reminderTimes: reminderTimes,
      isOnReminder: isOnReminder,
      timezoneDatabaseName: null,
      // BEGIN: Release function for trial user
      pillSheetAppearanceMode: PillSheetAppearanceMode.date,
      isAutomaticallyCreatePillSheet: true,
      // END: Release function for trial user
    );
    return setting;
  }

  static PillSheet buildPillSheet({
    required int pageIndex,
    required InitialSettingTodayPillNumber todayPillNumber,
    required List<PillSheetType> pillSheetTypes,
  }) {
    final pillSheetType = pillSheetTypes[pageIndex];
    final beginDate = _beginingDate(
      pageIndex: pageIndex,
      todayPillNumber: todayPillNumber,
      pillSheetTypes: pillSheetTypes,
    );
    final lastTakenDate = _lastTakenDate(
      pageIndex: pageIndex,
      todayPillNumber: todayPillNumber,
      pillSheetTypes: pillSheetTypes,
    );

    return PillSheet(
      id: firestoreIDGenerator(),
      groupIndex: pageIndex,
      beginingDate: beginDate,
      lastTakenDate: lastTakenDate,
      typeInfo: pillSheetType.typeInfo,
      createdAt: now(),
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
      final passedTotalCountElement = pillSheetTypes.sublist(0, todayPillNumber.pageIndex - pageIndex).map((e) => e.totalCount);
      final int passedTotalCount;
      if (passedTotalCountElement.isEmpty) {
        passedTotalCount = 0;
      } else {
        passedTotalCount = passedTotalCountElement.reduce((value, element) => value + element);
      }

      return today().subtract(Duration(days: passedTotalCount + (todayPillNumber.pillNumberInPillSheet - 1)));
    } else {
      // Right Side from todayPillNumber.pageIndex
      final beforePillSheetBeginingDate = _beginingDate(
        pageIndex: pageIndex - 1,
        todayPillNumber: todayPillNumber,
        pillSheetTypes: pillSheetTypes,
      );
      final beforePillSheetType = pillSheetTypes[pageIndex - 1];
      return beforePillSheetBeginingDate.addDays(beforePillSheetType.totalCount);
    }
  }

  static DateTime? _lastTakenDate({
    required int pageIndex,
    required InitialSettingTodayPillNumber todayPillNumber,
    required List<PillSheetType> pillSheetTypes,
  }) {
    if (pageIndex == 0 && todayPillNumber.pageIndex == 0 && todayPillNumber.pillNumberInPillSheet == 1) {
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
      ).addDays(pillSheetType.totalCount - 1);
    } else {
      // Current PillSheet
      return _beginingDate(
        pageIndex: pageIndex,
        todayPillNumber: todayPillNumber,
        pillSheetTypes: pillSheetTypes,
      ).addDays(todayPillNumber.pillNumberInPillSheet - 2);
    }
  }

  DateTime reminderDateTime(int index) {
    var t = DateTime.now();
    final reminderTime = reminderTimes[index];
    return DateTime(t.year, t.month, t.day, reminderTime.hour, reminderTime.minute, t.second, t.millisecond, t.microsecond);
  }

  int? selectedTodayPillNumberIntoPillSheet({required int pageIndex}) {
    if (todayPillNumber?.pageIndex != pageIndex) {
      return null;
    }
    return todayPillNumber?.pillNumberInPillSheet;
  }
}
