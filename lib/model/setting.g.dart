// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Reminder _$_$_ReminderFromJson(Map<String, dynamic> json) {
  return _$_Reminder(
    hour: json['hour'] as int,
    minute: json['minute'] as int,
  );
}

Map<String, dynamic> _$_$_ReminderToJson(_$_Reminder instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
    };

_$_Setting _$_$_SettingFromJson(Map<String, dynamic> json) {
  return _$_Setting(
    pillSheetTypeRawPath: json['pillSheetTypeRawPath'] as String,
    fromMenstruation: json['fromMenstruation'] as int,
    durationMenstruation: json['durationMenstruation'] as int,
    reminderTime: json['reminderTime'] == null
        ? null
        : ReminderTime.fromJson(json['reminderTime'] as Map<String, dynamic>),
    isOnReminder: json['isOnReminder'] as bool ?? false,
  );
}

Map<String, dynamic> _$_$_SettingToJson(_$_Setting instance) =>
    <String, dynamic>{
      'pillSheetTypeRawPath': instance.pillSheetTypeRawPath,
      'fromMenstruation': instance.fromMenstruation,
      'durationMenstruation': instance.durationMenstruation,
      'reminderTime': instance.reminderTime,
      'isOnReminder': instance.isOnReminder,
    };
