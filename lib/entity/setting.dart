import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'setting.g.dart';
part 'setting.freezed.dart';

@freezed
@JsonSerializable(explicitToJson: true)
class ReminderTime with _$ReminderTime {
  const ReminderTime._();
  const factory ReminderTime({
    required int hour,
    required int minute,
  }) = _ReminderTime;

  factory ReminderTime.fromJson(Map<String, dynamic> json) =>
      _$ReminderTimeFromJson(json);
  Map<String, dynamic> toJson() =>
      _$ReminderTimeToJson(this as _$_ReminderTime);

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
  @JsonValue("sequential")
  sequential,
}

class SettingFirestoreFieldKeys {
  static final pillSheetAppearanceMode = "pillSheetAppearanceMode";
}

@freezed
@JsonSerializable(explicitToJson: true)
class Setting with _$Setting {
  const Setting._();
  const factory Setting({
    @Default([]) List<PillSheetType> pillSheetTypes,
    required int pillNumberForFromMenstruation,
    required int durationMenstruation,
    @Default([]) List<ReminderTime> reminderTimes,
    required bool isOnReminder,
    @Default(true) bool isOnNotifyInNotTakenDuration,
    @Default(PillSheetAppearanceMode.number)
        PillSheetAppearanceMode pillSheetAppearanceMode,
    @Default(false) bool isAutomaticallyCreatePillSheet,
  }) = _Setting;

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);
  Map<String, dynamic> toJson() => _$SettingToJson(this as _$_Setting);
}
