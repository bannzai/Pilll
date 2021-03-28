// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menstruation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Menstruation _$_$_MenstruationFromJson(Map<String, dynamic> json) {
  return _$_Menstruation(
    date: DateTime.parse(json['date'] as String),
    physicalConditions: (json['physicalConditions'] as List<dynamic>)
        .map((e) => e as String)
        .toList(),
    hasSex: json['hasSex'] as bool,
    memo: json['memo'] as String,
  );
}

Map<String, dynamic> _$_$_MenstruationToJson(_$_Menstruation instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'physicalConditions': instance.physicalConditions,
      'hasSex': instance.hasSex,
      'memo': instance.memo,
    };
