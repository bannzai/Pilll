// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'affiliate.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Affiliate _$$_AffiliateFromJson(Map<String, dynamic> json) => _$_Affiliate(
      contents: (json['contents'] as List<dynamic>)
          .map((e) => AffiliateContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      version: json['version'] as String? ?? "999.999.999",
    );

Map<String, dynamic> _$$_AffiliateToJson(_$_Affiliate instance) =>
    <String, dynamic>{
      'contents': instance.contents.map((e) => e.toJson()).toList(),
      'version': instance.version,
    };

_$_AffiliateContent _$$_AffiliateContentFromJson(Map<String, dynamic> json) =>
    _$_AffiliateContent(
      imageURL: json['imageURL'] as String,
      destinationURL: json['destinationURL'] as String,
      isHidden: json['isHidden'] as bool? ?? false,
      version: json['version'] as String? ?? "999.999.999",
    );

Map<String, dynamic> _$$_AffiliateContentToJson(_$_AffiliateContent instance) =>
    <String, dynamic>{
      'imageURL': instance.imageURL,
      'destinationURL': instance.destinationURL,
      'isHidden': instance.isHidden,
      'version': instance.version,
    };
