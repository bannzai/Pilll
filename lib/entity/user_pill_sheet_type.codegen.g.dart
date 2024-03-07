// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_pill_sheet_type.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPillSheetTypeImpl _$$UserPillSheetTypeImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPillSheetTypeImpl(
      name: json['name'] as String,
      totalCount: json['totalCount'] as int,
      dosingPeriod: json['dosingPeriod'] as int,
      createdDateTime: NonNullTimestampConverter.timestampToDateTime(
          json['createdDateTime'] as Timestamp),
    );

Map<String, dynamic> _$$UserPillSheetTypeImplToJson(
        _$UserPillSheetTypeImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'totalCount': instance.totalCount,
      'dosingPeriod': instance.dosingPeriod,
      'createdDateTime': NonNullTimestampConverter.dateTimeToTimestamp(
          instance.createdDateTime),
    };
