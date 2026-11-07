import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/record/components/setting/components/rest_duration/invalid_already_taken_pill_dialog.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/utils/analytics.dart';

import '../../../../../../helper/fake.dart';

void main() {
  setUp(() {
    analytics = FakeAnalytics();
  });

  group('#InvalidAlreadyTakenPillDialog', () {
    // iPhone 17 の論理幅 (402pt) に合わせる。QA で de 表示のこのダイアログが読めないことが見つかった端末
    const iPhone17ScreenWidth = 402.0;
    // iOS 15 (アプリの最小対応) が動く端末で最も狭い論理幅 (iPhone SE 第 1 世代の 320pt)。説明図の固定幅の行が溢れないことを確かめるため
    const narrowestScreenWidth = 320.0;
    final hiraganaOrKatakana = RegExp(r'[぀-ヿ]');
    final cjkIdeograph = RegExp(r'[一-鿿]');

    /// [locale] の文言に差し替えた L で、論理幅 [screenWidth] の画面にダイアログを描画し、描画された RichText の平文を描画順に返す。
    /// L と画面サイズはテストの終わりに元へ戻す。
    Future<List<String>> pumpAndCollectTexts({
      required WidgetTester tester,
      required Locale locale,
      required double screenWidth,
    }) async {
      final originalL = L;
      addTearDown(() => L = originalL);
      L = lookupAppLocalizations(locale);
      tester.view.physicalSize = Size(screenWidth, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
            home: Scaffold(body: InvalidAlreadyTakenPillDialog())),
      );
      await tester.pump();

      return tester
          .widgetList<RichText>(find.byType(RichText))
          .map((richText) => richText.text.toPlainText())
          .toList();
    }

    for (final locale in AppLocalizations.supportedLocales
        .where((locale) => locale.languageCode != 'ja')) {
      testWidgets('${locale.languageCode} 表示ではダイアログ内の文言に平仮名・片仮名が出ず、レイアウトが溢れない',
          (tester) async {
        for (final text in await pumpAndCollectTexts(
            tester: tester, locale: locale, screenWidth: iPhone17ScreenWidth)) {
          expect(hiraganaOrKatakana.hasMatch(text), isFalse,
              reason: '${locale.languageCode}: $text');
        }
        expect(tester.takeException(), isNull);
      });
    }

    for (final languageCode in ['de', 'en']) {
      testWidgets('$languageCode 表示では説明図と本文に漢字が出ない', (tester) async {
        for (final text in await pumpAndCollectTexts(
            tester: tester,
            locale: Locale(languageCode),
            screenWidth: iPhone17ScreenWidth)) {
          expect(cjkIdeograph.hasMatch(text), isFalse,
              reason: '$languageCode: $text');
        }
      });
    }

    for (final languageCode in ['ja', 'de']) {
      testWidgets('$languageCode 表示で論理幅 320pt の画面でもレイアウトが溢れない', (tester) async {
        await pumpAndCollectTexts(
            tester: tester,
            locale: Locale(languageCode),
            screenWidth: narrowestScreenWidth);

        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('本文の 2 文は 1 つの段落に連結されず、それぞれ別の段落として描画される', (tester) async {
      // 見出し・説明図のラベル 4 つと矢印・本文 2 文・ボタン 2 つ。
      // 旧実装は本文 2 文を 1 つの RichText に連結しており 9 つだった (de で「…markiert hastBitte starte…」と読めなかった)
      expect(
          await pumpAndCollectTexts(
              tester: tester,
              locale: const Locale('de'),
              screenWidth: iPhone17ScreenWidth),
          hasLength(10));
    });

    testWidgets('ja 表示では説明図の文言が日本語で出る', (tester) async {
      expect(
        (await pumpAndCollectTexts(
                tester: tester,
                locale: const Locale('ja'),
                screenWidth: iPhone17ScreenWidth))
            .where((text) =>
                hiraganaOrKatakana.hasMatch(text) ||
                cjkIdeograph.hasMatch(text)),
        isNotEmpty,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
