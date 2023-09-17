// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pilll_ads.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PilllAds _$$_PilllAdsFromJson(Map<String, dynamic> json) => _$_PilllAds(
      startDateTime: NonNullTimestampConverter.timestampToDateTime(
          json['startDateTime'] as Timestamp),
      endDateTime: NonNullTimestampConverter.timestampToDateTime(
          json['endDateTime'] as Timestamp),
      description: json['description'] as String,
      imageURL: json['imageURL'] as String?,
      destinationURL: json['destinationURL'] as String,
      hexColor: json['hexColor'] as String,
      version: json['version'] as String? ?? "0.0.0",
    );

Map<String, dynamic> _$$_PilllAdsToJson(_$_PilllAds instance) =>
    <String, dynamic>{
      'startDateTime':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.startDateTime),
      'endDateTime':
          NonNullTimestampConverter.dateTimeToTimestamp(instance.endDateTime),
      'description': instance.description,
      'imageURL': instance.imageURL,
      'destinationURL': instance.destinationURL,
      'hexColor': instance.hexColor,
      'version': instance.version,
    };
