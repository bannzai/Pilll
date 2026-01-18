// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiry.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InquiryImpl _$$InquiryImplFromJson(Map<String, dynamic> json) => _$InquiryImpl(
  id: json['id'] as String?,
  inquiryType: $enumDecode(_$InquiryTypeEnumMap, json['inquiryType']),
  otherTypeText: json['otherTypeText'] as String?,
  email: json['email'] as String,
  content: json['content'] as String,
  createdAt: NonNullTimestampConverter.timestampToDateTime(json['createdAt'] as Timestamp),
);

Map<String, dynamic> _$$InquiryImplToJson(_$InquiryImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['inquiryType'] = _$InquiryTypeEnumMap[instance.inquiryType]!;
  val['otherTypeText'] = instance.otherTypeText;
  val['email'] = instance.email;
  val['content'] = instance.content;
  val['createdAt'] = NonNullTimestampConverter.dateTimeToTimestamp(instance.createdAt);
  return val;
}

const _$InquiryTypeEnumMap = {InquiryType.bugReport: 'bugReport', InquiryType.featureRequest: 'featureRequest', InquiryType.other: 'other'};
