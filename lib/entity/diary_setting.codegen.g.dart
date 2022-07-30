// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary_setting.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DiarySetting _$$_DiarySettingFromJson(Map<String, dynamic> json) =>
    _$_DiarySetting(
      physicalConditions: (json['physicalConditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          defaultPhysicalConditions,
    );

Map<String, dynamic> _$$_DiarySettingToJson(_$_DiarySetting instance) =>
    <String, dynamic>{
      'physicalConditions': instance.physicalConditions,
    };
