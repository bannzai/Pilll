// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReminderTimeImpl _$$ReminderTimeImplFromJson(Map<String, dynamic> json) => _$ReminderTimeImpl(
      hour: (json['hour'] as num).toInt(),
      minute: (json['minute'] as num).toInt(),
    );

Map<String, dynamic> _$$ReminderTimeImplToJson(_$ReminderTimeImpl instance) => <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
    };

_$SettingImpl _$$SettingImplFromJson(Map<String, dynamic> json) => _$SettingImpl(
      pillSheetTypes: (json['pillSheetTypes'] as List<dynamic>?)?.map((e) => $enumDecodeNullable(_$PillSheetTypeEnumMap, e)).toList() ?? const [],
      pillNumberForFromMenstruation: (json['pillNumberForFromMenstruation'] as num).toInt(),
      durationMenstruation: (json['durationMenstruation'] as num).toInt(),
      reminderTimes: (json['reminderTimes'] as List<dynamic>?)?.map((e) => ReminderTime.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      isOnReminder: json['isOnReminder'] as bool,
      isOnNotifyInNotTakenDuration: json['isOnNotifyInNotTakenDuration'] as bool? ?? true,
      isAutomaticallyCreatePillSheet: json['isAutomaticallyCreatePillSheet'] as bool? ?? false,
      reminderNotificationCustomization: json['reminderNotificationCustomization'] == null
          ? const ReminderNotificationCustomization()
          : ReminderNotificationCustomization.fromJson(json['reminderNotificationCustomization'] as Map<String, dynamic>),
      useCriticalAlert: json['useCriticalAlert'] as bool? ?? false,
      criticalAlertVolume: (json['criticalAlertVolume'] as num?)?.toDouble() ?? 0.5,
      timezoneDatabaseName: json['timezoneDatabaseName'] as String?,
    );

Map<String, dynamic> _$$SettingImplToJson(_$SettingImpl instance) => <String, dynamic>{
      'pillSheetTypes': instance.pillSheetTypes.map((e) => _$PillSheetTypeEnumMap[e]).toList(),
      'pillNumberForFromMenstruation': instance.pillNumberForFromMenstruation,
      'durationMenstruation': instance.durationMenstruation,
      'reminderTimes': instance.reminderTimes.map((e) => e.toJson()).toList(),
      'isOnReminder': instance.isOnReminder,
      'isOnNotifyInNotTakenDuration': instance.isOnNotifyInNotTakenDuration,
      'isAutomaticallyCreatePillSheet': instance.isAutomaticallyCreatePillSheet,
      'reminderNotificationCustomization': instance.reminderNotificationCustomization.toJson(),
      'useCriticalAlert': instance.useCriticalAlert,
      'criticalAlertVolume': instance.criticalAlertVolume,
      'timezoneDatabaseName': instance.timezoneDatabaseName,
    };

const _$PillSheetTypeEnumMap = {
  PillSheetType.pillsheet_21: 'pillsheet_21',
  PillSheetType.pillsheet_28_4: 'pillsheet_28_4',
  PillSheetType.pillsheet_28_7: 'pillsheet_28_7',
  PillSheetType.pillsheet_28_0: 'pillsheet_28_0',
  PillSheetType.pillsheet_24_0: 'pillsheet_24_0',
  PillSheetType.pillsheet_21_0: 'pillsheet_21_0',
  PillSheetType.pillsheet_24_rest_4: 'pillsheet_24_rest_4',
};
