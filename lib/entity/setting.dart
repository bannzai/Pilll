import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setting.g.dart';
part 'setting.freezed.dart';

@freezed
abstract class ReminderTime implements _$ReminderTime {
  const ReminderTime._();
  @JsonSerializable(explicitToJson: true)
  const factory ReminderTime({
    required int hour,
    required int minute,
  }) = _ReminderTime;

  factory ReminderTime.fromJson(Map<String, dynamic> json) =>
      _$ReminderTimeFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_ReminderTimeToJson(this as _$_ReminderTime);

  DateTime dateTime() {
    var t = DateTime.now().toLocal();
    return DateTime(t.year, t.month, t.day, hour, minute, t.second,
        t.millisecond, t.microsecond);
  }

  static final int maximumCount = 3;
  static final int minimumCount = 1;
}

enum PillSheetAppearanceMode {
  @JsonValue("number")
  number,
  @JsonValue("date")
  date,
}

extension PillSheetAppearanceModeFunctions on PillSheetAppearanceMode {
  String get itemName {
    switch (this) {
      case PillSheetAppearanceMode.number:
        return "ピル番号";
      case PillSheetAppearanceMode.date:
        return "日付";
    }
  }
}

@freezed
abstract class MenstruationSetting implements _$MenstruationSetting {
  @JsonSerializable(explicitToJson: true)
  factory MenstruationSetting({
    required int pillNumberForFromMenstruation,
    required int durationMenstruation,
  }) = _MenstruationSetting;

  factory MenstruationSetting.fromJson(Map<String, dynamic> json) =>
      _$MenstruationSettingFromJson(json);
  Map<String, dynamic> toJson() =>
      _$_$_MenstruationSettingToJson(this as _$_MenstruationSetting);
}

abstract class SettingFirestoreFieldKeys {
  static final pillSheetAppearanceMode = "pillSheetAppearanceMode";
}

@freezed
abstract class Setting implements _$Setting {
  Setting._();
  @JsonSerializable(explicitToJson: true)
  factory Setting({
    @Default([]) List<PillSheetType> pillSheetTypes,
    required List<MenstruationSetting> menstruations,
    @Default([]) List<ReminderTime> reminderTimes,
    @JsonSerializable(explicitToJson: true) required bool isOnReminder,
    @Default(true) bool isOnNotifyInNotTakenDuration,
    @Default(PillSheetAppearanceMode.number)
        PillSheetAppearanceMode pillSheetAppearanceMode,
    @Default(false) bool isAutomaticallyCreatePillSheet,
  }) = _Setting;

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);
  Map<String, dynamic> toJson() => _$_$_SettingToJson(this as _$_Setting);
}
