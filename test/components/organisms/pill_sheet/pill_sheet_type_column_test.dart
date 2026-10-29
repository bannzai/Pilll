import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/organisms/pill_sheet/pill_sheet_type_column.dart';
import 'package:pilll/components/template/pill_sheet_type_setting/pill_sheet_type_select_body_template.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/utils/analytics.dart';

import '../../../helper/fake.dart';

/// iOS でカードの欧文を描画する San Francisco の実体。テスト既定のフォント (全グリフが正方形) では語の幅が実機と大きく違い、折り返しを検証できないため
final _sanFranciscoFontFile = File('/System/Library/Fonts/SFNS.ttf');

void main() {
  setUpAll(() async {
    if (!_sanFranciscoFontFile.existsSync()) {
      return;
    }
    // カードの文字が指定する FontFamily.japanese は端末に無く、iOS では San Francisco で描画される。その状態をテストで再現する
    await (FontLoader(FontFamily.japanese)
          ..addFont(Future.value(
              ByteData.sublistView(_sanFranciscoFontFile.readAsBytesSync()))))
        .load();
  });
  setUp(() {
    analytics = FakeAnalytics();
  });

  group('#PillSheetTypeColumn', () {
    // iPhone SE (375pt) と iPhone 17 (402pt) の論理幅。カードの幅は段の幅の上限 (PillSheetTypeColumnConstant.width × 2 + 16) と画面幅から左右の余白を除いた幅の狭い方で決まる
    for (final screenWidth in [375.0, 402.0]) {
      // 語を空白で区切る言語。ja・zh・ko は San Francisco に字形が無く実機の幅を再現できないため対象にしない
      for (final lang in ['en', 'de', 'es', 'fr', 'pt']) {
        testWidgets('$lang・幅 ${screenWidth}pt で全カードの文字が語の途中で折り返さない',
            (tester) async {
          final originalL = L;
          addTearDown(() => L = originalL);
          L = lookupAppLocalizations(Locale(lang));
          tester.view.physicalSize = Size(screenWidth, 1200);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ListView(
                  children: [
                    PillSheetTypeSelectBodyTemplate(
                      selectedFirstPillSheetType: null,
                      onSelect: (_) {},
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pump();

          final paragraphs = tester
              .renderObjectList<RenderParagraph>(find.descendant(
                of: find.byType(PillSheetTypeColumn),
                matching: find.byType(RichText),
              ))
              .toList();
          expect(paragraphs, isNotEmpty);
          for (final paragraph in paragraphs) {
            final text = paragraph.text.toPlainText();
            var offset = 0;
            while (offset < text.length) {
              final word =
                  paragraph.getWordBoundary(TextPosition(offset: offset));
              // 1 語が 2 行以上にまたがると、選択範囲の矩形が行ごとに分かれて 2 つ以上になる
              expect(
                paragraph
                    .getBoxesForSelection(TextSelection(
                        baseOffset: word.start, extentOffset: word.end))
                    .map((box) => box.top)
                    .toSet(),
                hasLength(lessThanOrEqualTo(1)),
                reason:
                    '$lang: 「$text」の「${text.substring(word.start, word.end)}」',
              );
              offset = word.end > offset ? word.end : offset + 1;
            }
          }
          expect(tester.takeException(), isNull);
        }, skip: !_sanFranciscoFontFile.existsSync());
      }
    }
  });
}
