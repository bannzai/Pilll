// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menstruation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Menstruation _$_$_MenstruationFromJson(Map<String, dynamic> json) {
  return _$_Menstruation(
    begin: NonNullTimestampConverter.timestampToDateTime(
        json['begin'] as Timestamp),
    end:
        NonNullTimestampConverter.timestampToDateTime(json['end'] as Timestamp),
    isPreview: json['isPreview'] as bool,
  );
}

Map<String, dynamic> _$_$_MenstruationToJson(_$_Menstruation instance) =>
    <String, dynamic>{
      'begin': NonNullTimestampConverter.dateTimeToTimestamp(instance.begin),
      'end': NonNullTimestampConverter.dateTimeToTimestamp(instance.end),
      'isPreview': instance.isPreview,
    };
