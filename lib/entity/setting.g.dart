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
      'pillSheetAppearanceMode':
          _$PillSheetAppearanceModeEnumMap[instance.pillSheetAppearanceMode],
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
};
