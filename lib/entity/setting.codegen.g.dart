// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReminderTimeImpl _$$ReminderTimeImplFromJson(Map<String, dynamic> json) =>
    _$ReminderTimeImpl(
      hour: json['hour'] as int,
      minute: json['minute'] as int,
    );

Map<String, dynamic> _$$ReminderTimeImplToJson(_$ReminderTimeImpl instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'minute': instance.minute,
    };

_$SettingImpl _$$SettingImplFromJson(Map<String, dynamic> json) =>
    _$SettingImpl(
      pillSheetTypeInfos: (json['pillSheetTypeInfos'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : PillSheetTypeInfo.fromJson(e as Map<String, dynamic>))
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

Map<String, dynamic> _$$SettingImplToJson(_$SettingImpl instance) =>
    <String, dynamic>{
      'pillSheetTypeInfos':
          instance.pillSheetTypeInfos.map((e) => e?.toJson()).toList(),
      'pillNumberForFromMenstruation': instance.pillNumberForFromMenstruation,
      'durationMenstruation': instance.durationMenstruation,
      'reminderTimes': instance.reminderTimes.map((e) => e.toJson()).toList(),
      'isOnReminder': instance.isOnReminder,
      'isOnNotifyInNotTakenDuration': instance.isOnNotifyInNotTakenDuration,
      'pillSheetAppearanceMode':
          _$PillSheetAppearanceModeEnumMap[instance.pillSheetAppearanceMode]!,
      'isAutomaticallyCreatePillSheet': instance.isAutomaticallyCreatePillSheet,
      'reminderNotificationCustomization':
          instance.reminderNotificationCustomization.toJson(),
      'timezoneDatabaseName': instance.timezoneDatabaseName,
    };

const _$PillSheetAppearanceModeEnumMap = {
  PillSheetAppearanceMode.number: 'number',
  PillSheetAppearanceMode.date: 'date',
  PillSheetAppearanceMode.sequential: 'sequential',
};
