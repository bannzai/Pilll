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
    const screenWidth = 402.0;
    final hiraganaOrKatakana = RegExp(r'[぀-ヿ]');
    final cjkIdeograph = RegExp(r'[一-鿿]');

    Future<List<String>> pumpAndCollectTexts(
      WidgetTester tester,
      Locale locale,
    ) async {
      final originalL = L;
      addTearDown(() => L = originalL);
      L = lookupAppLocalizations(locale);
      tester.view.physicalSize = const Size(screenWidth, 900);
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
        final texts = await pumpAndCollectTexts(tester, locale);

        expect(tester.takeException(), isNull);
        for (final text in texts) {
          expect(hiraganaOrKatakana.hasMatch(text), isFalse,
              reason: '${locale.languageCode}: $text');
        }
      });
    }

    for (final languageCode in ['de', 'en']) {
      testWidgets('$languageCode 表示では説明図と本文に漢字が出ない', (tester) async {
        final texts = await pumpAndCollectTexts(tester, Locale(languageCode));

        for (final text in texts) {
          expect(cjkIdeograph.hasMatch(text), isFalse,
              reason: '$languageCode: $text');
        }
      });
    }

    testWidgets('本文の 2 文は 1 つの段落に連結されず、それぞれ別の段落として描画される', (tester) async {
      final texts = await pumpAndCollectTexts(tester, const Locale('de'));

      // 見出し・説明図のラベル 4 つと矢印・本文 2 文・ボタン 2 つ。
      // 旧実装は本文 2 文を 1 つの RichText に連結しており 9 つだった (de で「…markiert hastBitte starte…」と読めなかった)
      expect(texts, hasLength(10));
    });

    testWidgets('ja 表示では説明図の文言が日本語で出る', (tester) async {
      final texts = await pumpAndCollectTexts(tester, const Locale('ja'));

      expect(tester.takeException(), isNull);
      expect(
        texts.where((text) =>
            hiraganaOrKatakana.hasMatch(text) || cjkIdeograph.hasMatch(text)),
        isNotEmpty,
      );
    });
  });
}
