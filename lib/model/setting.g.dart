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
    pillSheetType:
        _$enumDecodeNullable(_$PillSheetTypeEnumMap, json['pillSheetType']),
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
      'pillSheetType': _$PillSheetTypeEnumMap[instance.pillSheetType],
      'fromMenstruation': instance.fromMenstruation,
      'durationMenstruation': instance.durationMenstruation,
      'reminderTime': instance.reminderTime,
      'isOnReminder': instance.isOnReminder,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$PillSheetTypeEnumMap = {
  PillSheetType.pillsheet_21: 'pillsheet_21',
  PillSheetType.pillsheet_28_4: 'pillsheet_28_4',
  PillSheetType.pillsheet_28_7: 'pillsheet_28_7',
};
