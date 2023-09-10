import 'package:freezed_annotation/freezed_annotation.dart';

part 'affiliate.codegen.freezed.dart';
part 'affiliate.codegen.g.dart';

@freezed
class Affiliate with _$Affiliate {
  @JsonSerializable(explicitToJson: true)
  factory Affiliate({
    required List<AffiliateContent> contents,

    // このフィールドの値より高い場合には、広告を表示しないので超すことは無い値をデフォルト値としている
    @Default("999.999.999") String version,
  }) = _Affiliate;
  Affiliate._();

  factory Affiliate.fromJson(Map<String, dynamic> json) => _$AffiliateFromJson(json);
}

@freezed
class AffiliateContent with _$AffiliateContent {
  @JsonSerializable(explicitToJson: true)
  factory AffiliateContent({
    required String imageURL,
    required String destinationURL,
    @Default(false) bool isHidden,
    // このフィールドの値より高い場合には、広告を表示しないので超すことは無い値をデフォルト値としている
    @Default("999.999.999") String version,
  }) = _AffiliateContent;
  AffiliateContent._();

  factory AffiliateContent.fromJson(Map<String, dynamic> json) => _$AffiliateContentFromJson(json);
}
