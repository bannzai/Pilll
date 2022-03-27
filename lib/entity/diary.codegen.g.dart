// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Diary _$$_DiaryFromJson(Map<String, dynamic> json) => _$_Diary(
      date: NonNullTimestampConverter.timestampToDateTime(
          json['date'] as Timestamp),
      createdAt: TimestampConverter.timestampToDateTime(
          json['createdAt'] as Timestamp?),
      physicalConditionStatus: $enumDecodeNullable(
          _$PhysicalConditionStatusEnumMap, json['physicalConditionStatus']),
      physicalConditions: (json['physicalConditions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      hasSex: json['hasSex'] as bool,
      memo: json['memo'] as String,
    );

Map<String, dynamic> _$$_DiaryToJson(_$_Diary instance) => <String, dynamic>{
      'date': NonNullTimestampConverter.dateTimeToTimestamp(instance.date),
      'createdAt': TimestampConverter.dateTimeToTimestamp(instance.createdAt),
      'physicalConditionStatus':
          _$PhysicalConditionStatusEnumMap[instance.physicalConditionStatus],
      'physicalConditions': instance.physicalConditions,
      'hasSex': instance.hasSex,
      'memo': instance.memo,
    };

const _$PhysicalConditionStatusEnumMap = {
  PhysicalConditionStatus.fine: 'fine',
  PhysicalConditionStatus.bad: 'bad',
};
