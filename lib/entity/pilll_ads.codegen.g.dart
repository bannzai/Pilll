// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pilll_ads.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PilllAds _$PilllAdsFromJson(Map<String, dynamic> json) => _PilllAds(
  startDateTime: NonNullTimestampConverter.timestampToDateTime(json['startDateTime'] as Timestamp),
  endDateTime: NonNullTimestampConverter.timestampToDateTime(json['endDateTime'] as Timestamp),
  description: json['description'] as String,
  imageURL: json['imageURL'] as String?,
  destinationURL: json['destinationURL'] as String,
  hexColor: json['hexColor'] as String,
  closeButtonColor: json['closeButtonColor'] as String? ?? 'FFFFFF',
  chevronRightColor: json['chevronRightColor'] as String? ?? 'FFFFFF',
);

Map<String, dynamic> _$PilllAdsToJson(_PilllAds instance) => <String, dynamic>{
  'startDateTime': NonNullTimestampConverter.dateTimeToTimestamp(instance.startDateTime),
  'endDateTime': NonNullTimestampConverter.dateTimeToTimestamp(instance.endDateTime),
  'description': instance.description,
  'imageURL': instance.imageURL,
  'destinationURL': instance.destinationURL,
  'hexColor': instance.hexColor,
  'closeButtonColor': instance.closeButtonColor,
  'chevronRightColor': instance.chevronRightColor,
};
