/// arb 言語コード → App Store Connect（fastlane）ロケール名の対応表。
///
/// この基盤における「どの言語を生成し、どのディレクトリ名で出力するか」の SSOT。
/// スクリーンショットの撮影ハーネス（test/appstore_screenshot）が参照する。
/// シェルスクリプト側はこの対応表を複製せず、生成済みディレクトリ名を辿って
/// fastlane/screenshots へ配置する（apply_variant.sh）。
///
/// 収録方針:
/// - arb（lib/l10n/app_*.arb）に存在し、かつ ASC がスクリーンショット用ロケールとして
///   対応している言語のみを収録する。
/// - ASC 側に地域違いの複数ロケール（es-ES/es-MX, pt-BR/pt-PT, zh-Hans/zh-Hant,
///   en-US/en-GB 等）がある言語は、arb が単一ファイルのため代表 1 ロケールへ寄せる。
/// - ASC に対応が無い言語（gsw, zu, sw, ka 等）や、arb に無い言語（fr 等）は対象外。
/// - nb と no は同一の ASC ロケール no に落ちるため、重複を避けて no のみ収録する。
const Map<String, String> arbToFastlaneLocale = {
  'ar': 'ar-SA',
  'ca': 'ca',
  'cs': 'cs',
  'da': 'da',
  'de': 'de-DE',
  'el': 'el',
  'en': 'en-US',
  'es': 'es-ES',
  'fi': 'fi',
  'he': 'he',
  'hi': 'hi',
  'hr': 'hr',
  'hu': 'hu',
  'id': 'id',
  'it': 'it',
  'ja': 'ja',
  'ko': 'ko',
  'ms': 'ms',
  'nl': 'nl-NL',
  'no': 'no',
  'pl': 'pl',
  'pt': 'pt-BR',
  'ro': 'ro',
  'ru': 'ru',
  'sk': 'sk',
  'sv': 'sv',
  'th': 'th',
  'tr': 'tr',
  'uk': 'uk',
  'vi': 'vi',
  'zh': 'zh-Hans',
};

/// 生成対象の全 arb 言語コード（[arbToFastlaneLocale] のキー）。
///
/// 撮影ハーネスで生成言語が指定されない場合の既定値に使う。
List<String> get allScreenshotLanguages => arbToFastlaneLocale.keys.toList();

/// arb 言語コードを ASC（fastlane）ロケール名へ変換する。
///
/// 対応表に無い言語コードはそのまま返す（未知の言語をエラーにせず、
/// arb コードのままディレクトリ名に使う）。
String fastlaneLocaleOf({required String lang}) {
  return arbToFastlaneLocale[lang] ?? lang;
}
