import 'package:freezed_annotation/freezed_annotation.dart';

part 'affiliate.codegen.freezed.dart';
part 'affiliate.codegen.g.dart';

@freezed
class Affiliate with _$Affiliate {
  @JsonSerializable(explicitToJson: true)
  const factory Affiliate({
    required List<AffiliateContent> contents,

    // このフィールドの値よりパッケージバージョンが高い場合には、広告を表示する。
    // なので最も低いバージョンをデフォルト値としている
    @Default("0.0.0") String version,
  }) = _Affiliate;
  const Affiliate._();

  factory Affiliate.fromJson(Map<String, dynamic> json) => _$AffiliateFromJson(json);
}

@freezed
class AffiliateContent with _$AffiliateContent {
  @JsonSerializable(explicitToJson: true)
  const factory AffiliateContent({
    String? backgroundColorHex,
    required String webViewURL,
  }) = _AffiliateContent;
  const AffiliateContent._();

  factory AffiliateContent.fromJson(Map<String, dynamic> json) => _$AffiliateContentFromJson(json);
}