// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ReminderTime _$$_ReminderTimeFromJson(Map<String, dynamic> json) =>
    _$_ReminderTime(
      hour: json['hour'] as int,
      minute: json['minute'] as int,
    );

Map<String, dynamic> _$$_ReminderTimeToJson(_$_ReminderTime instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
    };

_$_Setting _$$_SettingFromJson(Map<String, dynamic> json) => _$_Setting(
      pillSheetTypes: (json['pillSheetTypes'] as List<dynamic>?)
              ?.map((e) => $enumDecodeNullable(_$PillSheetTypeEnumMap, e))
              .toList() ??
          const [],
      pillNumberForFromMenstruation:
          json['pillNumberForFromMenstruation'] as int,
      durationMenstruation: json['durationMenstruation'] as int,
      reminderTimes: (json['reminderTimes'] as List<dynamic>?)
              ?.map((e) => ReminderTime.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isOnReminder: json['isOnReminder'] as bool,
      isOnNotifyInNotTakenDuration:
          json['isOnNotifyInNotTakenDuration'] as bool? ?? true,
      pillSheetAppearanceMode: $enumDecodeNullable(
              _$PillSheetAppearanceModeEnumMap,
              json['pillSheetAppearanceMode']) ??
          PillSheetAppearanceMode.number,
      isAutomaticallyCreatePillSheet:
          json['isAutomaticallyCreatePillSheet'] as bool? ?? false,
      reminderNotificationCustomization:
          json['reminderNotificationCustomization'] == null
              ? const ReminderNotificationCustomization()
              : ReminderNotificationCustomization.fromJson(
                  json['reminderNotificationCustomization']
                      as Map<String, dynamic>),
      timezoneDatabaseName: json['timezoneDatabaseName'] as String?,
    );

Map<String, dynamic> _$$_SettingToJson(_$_Setting instance) =>
    <String, dynamic>{
      'pillSheetTypes': instance.pillSheetTypes
          .map((e) => _$PillSheetTypeEnumMap[e])
          .toList(),
      'pillNumberForFromMenstruation': instance.pillNumberForFromMenstruation,
      'durationMenstruation': instance.durationMenstruation,
      'reminderTimes': instance.reminderTimes.map((e) => e.toJson()).toList(),
      'isOnReminder': instance.isOnReminder,
      'isOnNotifyInNotTakenDuration': instance.isOnNotifyInNotTakenDuration,
      'pillSheetAppearanceMode':
          _$PillSheetAppearanceModeEnumMap[instance.pillSheetAppearanceMode],
      'isAutomaticallyCreatePillSheet': instance.isAutomaticallyCreatePillSheet,
      'reminderNotificationCustomization':
          instance.reminderNotificationCustomization.toJson(),
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

const _$PillSheetAppearanceModeEnumMap = {
  PillSheetAppearanceMode.number: 'number',
  PillSheetAppearanceMode.date: 'date',
  PillSheetAppearanceMode.sequential: 'sequential',
};
