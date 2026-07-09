/// スペシャルオファーの訴求コピーの A/B テストバリアント。
///
/// Firebase Remote Config の `specialOfferingCopyVariant` パラメータで配信し、
/// バー・オファー画面の文言を切り替える。Analytics の各種イベントには
/// `copy_variant` パラメータとして [value] を送出して経路別に効果を計測する。
enum SpecialOfferingCopyVariant {
  /// 現行文言。
  defaultVariant('default'),

  /// 希少性・限定性を訴求する文言。
  scarcity('scarcity');

  const SpecialOfferingCopyVariant(this.value);

  /// Remote Config / Analytics で扱う文字列値。
  final String value;

  /// 文字列から対応するバリアントを返す。一致するものが無ければ [defaultVariant] を返す（安全側フォールバック）。
  static SpecialOfferingCopyVariant fromString(String value) {
    for (final variant in SpecialOfferingCopyVariant.values) {
      if (variant.value == value) {
        return variant;
      }
    }
    return SpecialOfferingCopyVariant.defaultVariant;
  }
}
