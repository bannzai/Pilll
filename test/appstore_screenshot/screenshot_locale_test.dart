import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/appstore_screenshot/screenshot_locale.dart';

void main() {
  test('撮影元32言語・通常ページ37ロケール・CPP代表31ロケールを定義する', () {
    expect(allScreenshotLanguages, hasLength(32));
    expect(allStoreScreenshotLocales, hasLength(37));
    expect(allCppScreenshotLocales, hasLength(31));
    expect(allScreenshotLanguages, containsAll(['fr', 'ru']));
    expect(
        allStoreScreenshotLocales,
        containsAll(
            ['fr-FR', 'en-AU', 'en-CA', 'en-GB', 'es-MX', 'pt-PT', 'zh-Hant']));
    expect(allStoreScreenshotLocales, isNot(contains('ru')));
    expect(allCppScreenshotLocales, isNot(contains('ru')));
  });

  test('地域別ロケールを共通のarb撮影元へ戻せる', () {
    expect(screenshotLanguageOf(locale: 'en-GB'), 'en');
    expect(screenshotLanguageOf(locale: 'es-MX'), 'es');
    expect(screenshotLanguageOf(locale: 'pt-PT'), 'pt');
    expect(screenshotLanguageOf(locale: 'zh-Hant'), 'zh');
    expect(screenshotLanguageOf(locale: 'fr-FR'), 'fr');
  });

  test('通常商品ページとCPPの出力枚数を計算できる', () {
    const screenshotsPerLocale = 5;
    final mainCount = allStoreScreenshotLocales.length * screenshotsPerLocale;
    final cppCount =
        (allCppScreenshotLocales.length * 4 + 1) * screenshotsPerLocale;

    expect(mainCount, 185);
    expect(cppCount, 625);
    expect(mainCount + cppCount, 810);
  });
}
