// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pill.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PillTakenImpl _$$PillTakenImplFromJson(Map<String, dynamic> json) => _$PillTakenImpl(
      recordedTakenDateTime: NonNullTimestampConverter.timestampToDateTime(json['recordedTakenDateTime'] as Timestamp),
      createdDateTime: NonNullTimestampConverter.timestampToDateTime(json['createdDateTime'] as Timestamp),
      updatedDateTime: NonNullTimestampConverter.timestampToDateTime(json['updatedDateTime'] as Timestamp),
      isAutomaticallyRecorded: json['isAutomaticallyRecorded'] as bool? ?? false,
    );

Map<String, dynamic> _$$PillTakenImplToJson(_$PillTakenImpl instance) => <String, dynamic>{
      'recordedTakenDateTime': NonNullTimestampConverter.dateTimeToTimestamp(instance.recordedTakenDateTime),
      'createdDateTime': NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDateTime),
      'updatedDateTime': NonNullTimestampConverter.dateTimeToTimestamp(instance.updatedDateTime),
      'isAutomaticallyRecorded': instance.isAutomaticallyRecorded,
    };

_$PillImpl _$$PillImplFromJson(Map<String, dynamic> json) => _$PillImpl(
      index: (json['index'] as num).toInt(),
      createdDateTime: NonNullTimestampConverter.timestampToDateTime(json['createdDateTime'] as Timestamp),
      updatedDateTime: NonNullTimestampConverter.timestampToDateTime(json['updatedDateTime'] as Timestamp),
      pillTakens: (json['pillTakens'] as List<dynamic>).map((e) => PillTaken.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$$PillImplToJson(_$PillImpl instance) => <String, dynamic>{
      'index': instance.index,
      'createdDateTime': NonNullTimestampConverter.dateTimeToTimestamp(instance.createdDateTime),
      'updatedDateTime': NonNullTimestampConverter.dateTimeToTimestamp(instance.updatedDateTime),
      'pillTakens': instance.pillTakens.map((e) => e.toJson()).toList(),
    };
