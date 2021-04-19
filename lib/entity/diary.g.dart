// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Diary _$_$_DiaryFromJson(Map<String, dynamic> json) {
  return _$_Diary(
    date: NonNullTimestampConverter.timestampToDateTime(
        json['date'] as Timestamp),
    createdAt:
        TimestampConverter.timestampToDateTime(json['createdAt'] as Timestamp?),
    physicalConditionStatus: _$enumDecodeNullable(
        _$PhysicalConditionStatusEnumMap, json['physicalConditionStatus']),
    physicalConditions: (json['physicalConditions'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    hasSex: json['hasSex'] as bool,
    memo: json['memo'] as String,
  );
}

Map<String, dynamic> _$_$_DiaryToJson(_$_Diary instance) => <String, dynamic>{
      'date': NonNullTimestampConverter.dateTimeToTimestamp(instance.date),
      'createdAt': TimestampConverter.dateTimeToTimestamp(instance.createdAt),
      'physicalConditionStatus':
          _$PhysicalConditionStatusEnumMap[instance.physicalConditionStatus],
      'physicalConditions': instance.physicalConditions,
      'hasSex': instance.hasSex,
      'memo': instance.memo,
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

const _$PhysicalConditionStatusEnumMap = {
  PhysicalConditionStatus.fine: 'fine',
  PhysicalConditionStatus.bad: 'bad',
};
