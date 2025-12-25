// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiry.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Inquiry _$InquiryFromJson(Map<String, dynamic> json) => _Inquiry(
  id: json['id'] as String?,
  inquiryType: $enumDecode(_$InquiryTypeEnumMap, json['inquiryType']),
  otherTypeText: json['otherTypeText'] as String?,
  email: json['email'] as String,
  content: json['content'] as String,
  createdAt: NonNullTimestampConverter.timestampToDateTime(json['createdAt'] as Timestamp),
);

Map<String, dynamic> _$InquiryToJson(_Inquiry instance) => <String, dynamic>{
  'id': ?instance.id,
  'inquiryType': _$InquiryTypeEnumMap[instance.inquiryType]!,
  'otherTypeText': instance.otherTypeText,
  'email': instance.email,
  'content': instance.content,
  'createdAt': NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt),
};

const _$InquiryTypeEnumMap = {InquiryType.bugReport: 'bugReport', InquiryType.featureRequest: 'featureRequest', InquiryType.other: 'other'};
