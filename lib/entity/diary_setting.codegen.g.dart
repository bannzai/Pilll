// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_setting.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DiarySettingImpl _$$DiarySettingImplFromJson(Map<String, dynamic> json) =>
    _$DiarySettingImpl(
      physicalConditions: (json['physicalConditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          defaultPhysicalConditions,
      createdAt: NonNullTimestampConverter.timestampToDateTime(
          json['createdAt'] as Timestamp),
    );

Map<String, dynamic> _$$DiarySettingImplToJson(_$DiarySettingImpl instance) =>
    <String, dynamic>{
      'physicalConditions': instance.physicalConditions,
      'createdAt':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt),
    };
