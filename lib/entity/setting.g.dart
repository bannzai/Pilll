// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReminderTime _$_$_ReminderTimeFromJson(Map<String, dynamic> json) {
  return _$_ReminderTime(
    hour: json['hour'] as int,
    minute: json['minute'] as int,
  );
}

Map<String, dynamic> _$_$_ReminderTimeToJson(_$_ReminderTime instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
    };

_$_Setting _$_$_SettingFromJson(Map<String, dynamic> json) {
  return _$_Setting(
    pillSheetTypeRawPath: json['pillSheetTypeRawPath'] as String,
    pillNumberForFromMenstruation: json['pillNumberForFromMenstruation'] as int,
    durationMenstruation: json['durationMenstruation'] as int,
    reminderTimes: (json['reminderTimes'] as List<dynamic>)
        .map((e) => ReminderTime.fromJson(e as Map<String, dynamic>))
        .toList(),
    isOnReminder: json['isOnReminder'] as bool,
    isOnNotifyInNotTakenDuration:
        json['isOnNotifyInNotTakenDuration'] as bool? ?? true,
  );
}

Map<String, dynamic> _$_$_SettingToJson(_$_Setting instance) =>
    <String, dynamic>{
      'pillSheetTypeRawPath': instance.pillSheetTypeRawPath,
      'pillNumberForFromMenstruation': instance.pillNumberForFromMenstruation,
      'durationMenstruation': instance.durationMenstruation,
      'reminderTimes': instance.reminderTimes.map((e) => e.toJson()).toList(),
      'isOnReminder': instance.isOnReminder,
      'isOnNotifyInNotTakenDuration': instance.isOnNotifyInNotTakenDuration,
    };
