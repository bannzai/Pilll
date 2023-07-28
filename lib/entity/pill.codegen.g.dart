// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PillTaken _$$_PillTakenFromJson(Map<String, dynamic> json) => _$_PillTaken(
      recordedTakenDateTime: NonNullTimestampConverter.timestampToDateTime(
          json['recordedTakenDateTime'] as Timestamp),
      createdDateTime: NonNullTimestampConverter.timestampToDateTime(
          json['createdDateTime'] as Timestamp),
      updatedDateTime: NonNullTimestampConverter.timestampToDateTime(
          json['updatedDateTime'] as Timestamp),
      isAutomaticallyRecorded:
          json['isAutomaticallyRecorded'] as bool? ?? false,
    );

Map<String, dynamic> _$$_PillTakenToJson(_$_PillTaken instance) =>
    <String, dynamic>{
      'recordedTakenDateTime': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.recordedTakenDateTime),
      'createdDateTime': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.createdDateTime),
      'updatedDateTime': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.updatedDateTime),
      'isAutomaticallyRecorded': instance.isAutomaticallyRecorded,
    };

_$_Pill _$$_PillFromJson(Map<String, dynamic> json) => _$_Pill(
      index: json['index'] as int,
      createdDateTime: NonNullTimestampConverter.timestampToDateTime(
          json['createdDateTime'] as Timestamp),
      updatedDateTime: NonNullTimestampConverter.timestampToDateTime(
          json['updatedDateTime'] as Timestamp),
      pillTakens: (json['pillTakens'] as List<dynamic>)
          .map((e) => PillTaken.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_PillToJson(_$_Pill instance) => <String, dynamic>{
      'index': instance.index,
      'createdDateTime': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.createdDateTime),
      'updatedDateTime': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.updatedDateTime),
      'pillTakens': instance.pillTakens.map((e) => e.toJson()).toList(),
    };
