// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderTime _$ReminderTimeFromJson(Map<String, dynamic> json) {
  return ReminderTime(
    hour: json['hour'] as int,
    minute: json['minute'] as int,
  );
}

Map<String, dynamic> _$ReminderTimeToJson(ReminderTime instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
    };

Setting _$SettingFromJson(Map<String, dynamic> json) {
  return Setting(
    pillSheetTypeRawPath: json['pillSheetTypeRawPath'] as String,
    fromMenstruation: json['fromMenstruation'] as int,
    durationMenstruation: json['durationMenstruation'] as int,
    reminderTime: json['reminderTime'] == null
        ? null
        : ReminderTime.fromJson(json['reminderTime'] as Map<String, dynamic>),
    isOnReminder: json['isOnReminder'] as bool ?? false,
  );
}

Map<String, dynamic> _$SettingToJson(Setting instance) => <String, dynamic>{
      'pillSheetTypeRawPath': instance.pillSheetTypeRawPath,
      'fromMenstruation': instance.fromMenstruation,
      'durationMenstruation': instance.durationMenstruation,
      'reminderTime': instance.reminderTime,
      'isOnReminder': instance.isOnReminder,
    };
