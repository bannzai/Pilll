// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'affiliate.codegen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Affiliate _$$_AffiliateFromJson(Map<String, dynamic> json) => _$_Affiliate(
      contents: (json['contents'] as List<dynamic>)
          .map((e) => AffiliateContent.fromJson(e as Map<String, dynamic>))
          .toList(),
      version: json['version'] as String? ?? "0.0.0",
    );

Map<String, dynamic> _$$_AffiliateToJson(_$_Affiliate instance) =>
    <String, dynamic>{
      'contents': instance.contents.map((e) => e.toJson()).toList(),
      'version': instance.version,
    };

_$_AffiliateContent _$$_AffiliateContentFromJson(Map<String, dynamic> json) =>
    _$_AffiliateContent(
      backgroundColorHex: json['backgroundColorHex'] as String?,
      webViewURL: json['webViewURL'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
    );

Map<String, dynamic> _$$_AffiliateContentToJson(_$_AffiliateContent instance) =>
    <String, dynamic>{
      'backgroundColorHex': instance.backgroundColorHex,
      'webViewURL': instance.webViewURL,
      'width': instance.width,
      'height': instance.height,
    };
