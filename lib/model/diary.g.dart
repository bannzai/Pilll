// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Diary _$_$_DiaryFromJson(Map<String, dynamic> json) {
  return _$_Diary(
    date: TimestampConverter.timestampToDateTime(json['date'] as Timestamp),
    memo: json['memo'] as String,
    physicalCondtions:
        (json['physicalCondtions'] as List).map((e) => e as String).toList(),
    hasSex: json['hasSex'] as bool,
  );
}

Map<String, dynamic> _$_$_DiaryToJson(_$_Diary instance) => <String, dynamic>{
      'date': TimestampConverter.dateTimeToTimestamp(instance.date),
      'memo': instance.memo,
      'physicalCondtions': instance.physicalCondtions,
      'hasSex': instance.hasSex,
    };
