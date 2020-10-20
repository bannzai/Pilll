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
    fromMenstruation: json['fromMenstruation'] as int,
    durationMenstruation: json['durationMenstruation'] as int,
    reminderTimes: (json['reminderTimes'] as List)
        ?.map((e) =>
            e == null ? null : ReminderTime.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    isOnReminder: json['isOnReminder'] as bool,
  );
}

Map<String, dynamic> _$_$_SettingToJson(_$_Setting instance) =>
    <String, dynamic>{
      'pillSheetTypeRawPath': instance.pillSheetTypeRawPath,
      'fromMenstruation': instance.fromMenstruation,
      'durationMenstruation': instance.durationMenstruation,
      'reminderTimes':
          instance.reminderTimes?.map((e) => e?.toJson())?.toList(),
      'isOnReminder': instance.isOnReminder,
    };
