import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pilll/entity/reminder_notification_customization.codegen.dart';

part 'setting.codegen.g.dart';
part 'setting.codegen.freezed.dart';

@freezed
class ReminderTime with _$ReminderTime {
  const ReminderTime._();
  @JsonSerializable(explicitToJson: true)
  const factory ReminderTime({
    required int hour,
    required int minute,
  }) = _ReminderTime;

  factory ReminderTime.fromJson(Map<String, dynamic> json) => _$ReminderTimeFromJson(json);

  DateTime dateTime() {
    var t = DateTime.now().toLocal();
    return DateTime(t.year, t.month, t.day, hour, minute, t.second, t.millisecond, t.microsecond);
  }

  static const int maximumCount = 3;
  static const int minimumCount = 1;
}

enum PillSheetAppearanceMode {
  @JsonValue("number")
  number,
  @JsonValue("date")
  date,
  @JsonValue("sequential")
  sequential,
}

class SettingFirestoreFieldKeys {
  static const pillSheetAppearanceMode = "pillSheetAppearanceMode";
  static const timezoneDatabaseName = "timezoneDatabaseName";
}

@freezed
class Setting with _$Setting {
  const Setting._();
  @JsonSerializable(explicitToJson: true)
  const factory Setting({
    @Default([]) List<PillSheetType?> pillSheetTypeInfos,
    required int pillNumberForFromMenstruation,
    required int durationMenstruation,
    @Default([]) List<ReminderTime> reminderTimes,
    required bool isOnReminder,
    @Default(true) bool isOnNotifyInNotTakenDuration,
    @Default(PillSheetAppearanceMode.number) PillSheetAppearanceMode pillSheetAppearanceMode,
    @Default(false) bool isAutomaticallyCreatePillSheet,
    @Default(ReminderNotificationCustomization()) ReminderNotificationCustomization reminderNotificationCustomization,
    required String? timezoneDatabaseName,
  }) = _Setting;

  factory Setting.fromJson(Map<String, dynamic> json) => _$SettingFromJson(json);

  // NOTE: v3.9.6 で PillSheetType.pillsheet_24_rest_4 を含めた状態でのコード生成をしていなかった
  // 本来初期設定でpillsheet_24_rest_4を選択したユーザーの pillSheetTypeInfos の値が null が入ってしまっている
  List<PillSheetType> get pillSheetEnumTypes {
    return backportPillSheetTypes(pillSheetTypeInfos);
  }
}

List<PillSheetType> backportPillSheetTypes(List<PillSheetType?> pillSheetTypeInfos) {
  return pillSheetTypeInfos.map((e) => e ?? PillSheetType.pillsheet_24_rest_4).toList();
}
