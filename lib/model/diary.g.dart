// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Diary _$_$_DiaryFromJson(Map<String, dynamic> json) {
  return _$_Diary(
    date: TimestampConverter.timestampToDateTime(json['date'] as Timestamp),
    physicalConditionStatus: _$enumDecode(
        _$PhysicalConditionStatusEnumMap, json['physicalConditionStatus']),
    physicalConditions:
        (json['physicalConditions'] as List).map((e) => e as String).toList(),
    hasSex: json['hasSex'] as bool,
    memo: json['memo'] as String,
  );
}

Map<String, dynamic> _$_$_DiaryToJson(_$_Diary instance) => <String, dynamic>{
      'date': TimestampConverter.dateTimeToTimestamp(instance.date),
      'physicalConditionStatus':
          _$PhysicalConditionStatusEnumMap[instance.physicalConditionStatus],
      'physicalConditions': instance.physicalConditions,
      'hasSex': instance.hasSex,
      'memo': instance.memo,
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

const _$PhysicalConditionStatusEnumMap = {
  PhysicalConditionStatus.fine: 'fine',
  PhysicalConditionStatus.bad: 'bad',
};
