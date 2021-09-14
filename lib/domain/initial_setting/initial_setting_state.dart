import 'package:pilll/util/datetime/day.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/setting.dart';

part 'initial_setting_state.freezed.dart';

@freezed
abstract class InitialSettingTodayPillNumber
    implements _$InitialSettingTodayPillNumber {
  factory InitialSettingTodayPillNumber({
    @Default(0) pageIndex,
    @Default(0) pillNumberIntoPillSheet,
  }) = _InitialSettingTodayPillNumber;
}

@freezed
abstract class InitialSettingState implements _$InitialSettingState {
  InitialSettingState._();
  factory InitialSettingState({
    @Default([])
        List<PillSheetType> pillSheetTypes,
    InitialSettingTodayPillNumber? todayPillNumber,
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
    @Default(false)
        bool isLoading,
    @Default(false)
        bool isAccountCooperationDidEnd,
    @Default(0)
        currentMenstruationPageIndex,
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

  MenstruationSetting get focusedMenstruation =>
      menstruations[currentMenstruationPageIndex];

  Setting buildSetting() => Setting(
        menstruations: menstruations,
        pillSheetTypes: pillSheetTypes,
        reminderTimes: reminderTimes,
        isOnReminder: isOnReminder,
      );

  PillSheet buildPillSheet({
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

  DateTime _beginingDate({
    required int pageIndex,
    required InitialSettingTodayPillNumber todayPillNumber,
    required List<PillSheetType> pillSheetTypes,
  }) {
    // Avoid broken type inherence
    // todayPillNumber.pillNumberIntoPillSheet interpreted as dynamic
    final int pillNumberIntoPillSheet = todayPillNumber.pillNumberIntoPillSheet;
    if (pageIndex <= todayPillNumber.pageIndex) {
      // Left side from todayPillNumber.pageIndex
      // Or current pageIndex == todayPillNumber.pageIndex
      final pastedTotalCountElement = pillSheetTypes
          .sublist(0, todayPillNumber.pageIndex - pageIndex)
          .map((e) => e.totalCount);
      final int pastedTotalCount;
      if (pastedTotalCountElement.isEmpty) {
        pastedTotalCount = 0;
      } else {
        pastedTotalCount =
            pastedTotalCountElement.reduce((value, element) => value + element);
      }

      return today().subtract(
          Duration(days: pastedTotalCount + (pillNumberIntoPillSheet - 1)));
    } else {
      // Right Side from todayPillNumber.pageIndex
      final beforePillSheetType = pillSheetTypes[pageIndex - 1];
      return today().add(Duration(
          days:
              beforePillSheetType.totalCount - (pillNumberIntoPillSheet - 1)));
    }
  }

  DateTime? _lastTakenDate({
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
    final pillSheetBeginPillNumber = pageIndex * pillSheetType.totalCount + 1;
    final pillSheetEndPillNumber =
        pastedTotalCount(pillSheetTypes: pillSheetTypes, pageIndex: pageIndex) +
            pillSheetType.totalCount;
    if (pillSheetBeginPillNumber <= todayPillNumber.pillNumberIntoPillSheet &&
        todayPillNumber.pillNumberIntoPillSheet <= pillSheetEndPillNumber) {
      // Between current PillSheet
      return today().subtract(Duration(days: 1));
    } else if (todayPillNumber.pillNumberIntoPillSheet <
        pillSheetEndPillNumber) {
      // Right side PillSheet
      return null;
    } else {
      // Left side PillSheet
      return _beginingDate(
        pageIndex: pageIndex,
        todayPillNumber: todayPillNumber,
        pillSheetTypes: pillSheetTypes,
      ).add(Duration(days: pillSheetType.totalCount - 1));
    }
  }

  DateTime reminderDateTime(int index) {
    var t = DateTime.now();
    final reminderTime = reminderTimes[index];
    return DateTime(t.year, t.month, t.day, reminderTime.hour,
        reminderTime.minute, t.second, t.millisecond, t.microsecond);
  }
}
