import 'package:Pilll/entity/pill_sheet_type.dart';
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
    @required int hour,
    @required int minute,
  }) = _ReminderTime;

  factory ReminderTime.fromJson(Map<String, dynamic> json) =>
      _$ReminderTimeFromJson(json);
  Map<String, dynamic> toJson() => _$_$_ReminderTimeToJson(this);

  DateTime dateTime() {
    var t = DateTime.now().toLocal();
    return DateTime(t.year, t.month, t.day, hour, minute, t.second,
        t.millisecond, t.microsecond);
  }

  static final int maximumCount = 3;
  static final int minimumCount = 1;
}

@freezed
abstract class Setting implements _$Setting {
  Setting._();
  @JsonSerializable(explicitToJson: true)
  factory Setting({
    @required String pillSheetTypeRawPath,
    @required int pillNumberForFromMenstruation,
    @required int durationMenstruation,
    @required List<ReminderTime> reminderTimes,
    @required @JsonSerializable(explicitToJson: true) bool isOnReminder,
    @Default(true) bool isOnNotifyInNotTakenDuration,
  }) = _Setting;

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);
  Map<String, dynamic> toJson() => _$_$_SettingToJson(this);

  PillSheetType get pillSheetType =>
      PillSheetTypeFunctions.fromRawPath(pillSheetTypeRawPath);
}
