/// 買い切りオファーの訴求コピーの A/B テストバリアント。
///
/// Firebase Remote Config の `lifetimeOfferCopyVariant` パラメータで配信し、
/// バー・オファー画面の文言を切り替える。Analytics の各種イベントには
/// `copy_variant` パラメータとして [value] を送出して経路別に効果を計測する。
enum LifetimeOfferCopyVariant {
  /// 現行文言。
  defaultVariant('default'),

  /// 買い切りの所有価値（一度の購入でずっと使える）を訴求する文言。
  ownership('ownership');

  const LifetimeOfferCopyVariant(this.value);

  /// Remote Config / Analytics で扱う文字列値。
  final String value;

  /// 文字列から対応するバリアントを返す。一致するものが無ければ [defaultVariant] を返す（安全側フォールバック）。
  static LifetimeOfferCopyVariant fromString(String value) {
    for (final variant in LifetimeOfferCopyVariant.values) {
      if (variant.value == value) {
        return variant;
      }
    }
    return LifetimeOfferCopyVariant.defaultVariant;
  }
}
