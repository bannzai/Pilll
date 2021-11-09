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
    pillSheetTypes: (json['pillSheetTypes'] as List<dynamic>?)
            ?.map((e) => _$enumDecode(_$PillSheetTypeEnumMap, e))
            .toList() ??
        [],
    pillNumberForFromMenstruation: json['pillNumberForFromMenstruation'] as int,
    durationMenstruation: json['durationMenstruation'] as int,
    reminderTimes: (json['reminderTimes'] as List<dynamic>?)
            ?.map((e) => ReminderTime.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    isOnReminder: json['isOnReminder'] as bool,
    isOnNotifyInNotTakenDuration:
        json['isOnNotifyInNotTakenDuration'] as bool? ?? true,
    pillSheetAppearanceMode: _$enumDecodeNullable(
            _$PillSheetAppearanceModeEnumMap,
            json['pillSheetAppearanceMode']) ??
        PillSheetAppearanceMode.number,
    isAutomaticallyCreatePillSheet:
        json['isAutomaticallyCreatePillSheet'] as bool? ?? false,
  );
}

Map<String, dynamic> _$_$_SettingToJson(_$_Setting instance) =>
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
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$PillSheetTypeEnumMap = {
  PillSheetType.pillsheet_21: 'pillsheet_21',
  PillSheetType.pillsheet_28_4: 'pillsheet_28_4',
  PillSheetType.pillsheet_28_7: 'pillsheet_28_7',
  PillSheetType.pillsheet_28_0: 'pillsheet_28_0',
  PillSheetType.pillsheet_24_0: 'pillsheet_24_0',
  PillSheetType.pillsheet_21_0: 'pillsheet_21_0',
};

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$PillSheetAppearanceModeEnumMap = {
  PillSheetAppearanceMode.number: 'number',
  PillSheetAppearanceMode.date: 'date',
  PillSheetAppearanceMode.sequential: 'sequential',
};
