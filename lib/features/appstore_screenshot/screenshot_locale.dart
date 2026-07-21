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
/// - ASC 側に地域違いの複数ロケールがある言語は、同じarb撮影元を全対象へ展開する。
/// - ASC に対応が無い言語（gsw, zu, sw, ka 等）は対象外。
/// - ru は比較用に撮影するが、通常商品ページとCPPへは配置しない。
/// - nb と no は同一の ASC ロケール no に落ちるため、重複を避けて no のみ収録する。
const Map<String, List<String>> arbToFastlaneLocales = {
  'ar': ['ar-SA'],
  'ca': ['ca'],
  'cs': ['cs'],
  'da': ['da'],
  'de': ['de-DE'],
  'el': ['el'],
  'en': ['en-US', 'en-AU', 'en-CA', 'en-GB'],
  'es': ['es-ES', 'es-MX'],
  'fi': ['fi'],
  'fr': ['fr-FR'],
  'he': ['he'],
  'hi': ['hi'],
  'hr': ['hr'],
  'hu': ['hu'],
  'id': ['id'],
  'it': ['it'],
  'ja': ['ja'],
  'ko': ['ko'],
  'ms': ['ms'],
  'nl': ['nl-NL'],
  'no': ['no'],
  'pl': ['pl'],
  'pt': ['pt-BR', 'pt-PT'],
  'ro': ['ro'],
  'ru': ['ru'],
  'sk': ['sk'],
  'sv': ['sv'],
  'th': ['th'],
  'tr': ['tr'],
  'uk': ['uk'],
  'vi': ['vi'],
  'zh': ['zh-Hans', 'zh-Hant'],
};

/// 生成対象の全 arb 言語コード（[arbToFastlaneLocales] のキー）。
///
/// 撮影ハーネスで生成言語が指定されない場合の既定値に使う。
List<String> get allScreenshotLanguages => arbToFastlaneLocales.keys.toList();

/// 通常商品ページへ配置する全ロケール。ru は ASC の対象外なので撮影専用とする。
List<String> get allStoreScreenshotLocales => [
      for (final entry in arbToFastlaneLocales.entries)
        if (entry.key != 'ru') ...entry.value,
    ];

/// CPPへ配置する代表ロケール。地域別派生は通常商品ページだけに展開する。
List<String> get allCppScreenshotLocales => [
      for (final entry in arbToFastlaneLocales.entries)
        if (entry.key != 'ru') entry.value.first,
    ];

/// ASCロケールの撮影元となるarb言語コードを返す。
String screenshotLanguageOf({required String locale}) =>
    arbToFastlaneLocales.entries.firstWhere((entry) => entry.value.contains(locale), orElse: () => MapEntry(locale, [locale])).key;

/// arb 言語コードを ASC（fastlane）ロケール名へ変換する。
///
/// 対応表に無い言語コードはそのまま返す（未知の言語をエラーにせず、
/// arb コードのままディレクトリ名に使う）。
String fastlaneLocaleOf({required String lang}) {
  return arbToFastlaneLocales[lang]?.first ?? lang;
}
