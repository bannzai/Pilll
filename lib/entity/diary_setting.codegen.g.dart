// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_setting.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DiarySetting _$DiarySettingFromJson(Map<String, dynamic> json) => _DiarySetting(
  physicalConditions: (json['physicalConditions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? defaultPhysicalConditions,
  createdAt: NonNullTimestampConverter.timestampToDateTime(json['createdAt'] as Timestamp),
);

Map<String, dynamic> _$DiarySettingToJson(_DiarySetting instance) => <String, dynamic>{
  'physicalConditions': instance.physicalConditions,
  'createdAt': NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt),
};
