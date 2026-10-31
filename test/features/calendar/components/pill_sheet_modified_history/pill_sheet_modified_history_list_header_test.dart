import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list_header.dart';

void main() {
  group('#PillSheetModifiedHistoryListHeaderWrappedLabel', () {
    // 服用履歴の「服用済み」列と同じ幅
    const columnWidth = 57.0;
    const style = TextStyle(fontSize: 12);

    /// 列の幅に置いた見出しを返す。text は見出しの訳語
    Widget subject({required String text}) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: columnWidth,
              child: PillSheetModifiedHistoryListHeaderWrappedLabel(
                text: text,
                style: style,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets(
      '列の幅より長い語を含む場合 (de「Pille eingenommen」)、語の境界で 2 行に折り返し、列の幅に収まるまで縮小する',
      (WidgetTester tester) async {
        const text = 'Pille eingenommen';
        await tester.pumpWidget(subject(text: text));

        expect(tester.takeException(), isNull);
        final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
        final lineTops = paragraph
            .getBoxesForSelection(
                const TextSelection(baseOffset: 0, extentOffset: text.length))
            .map((box) => box.top)
            .toSet()
            .toList()
          ..sort();
        expect(lineTops.length, 2);
        expect(
            text
                .substring(paragraph
                    .getPositionForOffset(Offset(0, lineTops[1] + 1))
                    .offset)
                .trim(),
            'eingenommen');
        expect(
          tester.getRect(find.text(text)).width,
          lessThanOrEqualTo(columnWidth),
        );
      },
    );

    testWidgets('語の間に空白を入れない言語で列の幅より長い場合、1 行に縮小せず列の幅で折り返す',
        (WidgetTester tester) async {
      // 中国語は文字ごとに改行できる。テストのフォントは 1 文字 12 なので、10 文字 (120) は列の幅 57 を超える
      const text = '已服药已服药已服药已';
      await tester.pumpWidget(subject(text: text));

      expect(tester.takeException(), isNull);
      final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
      expect(
        paragraph
            .getBoxesForSelection(
                const TextSelection(baseOffset: 0, extentOffset: text.length))
            .map((box) => box.top)
            .toSet()
            .length,
        greaterThan(1),
      );
      expect(tester.getRect(find.text(text)).width, paragraph.size.width);
    });

    testWidgets('列の幅に収まる語だけの場合は縮小せず、列の幅で折り返す', (WidgetTester tester) async {
      // テストのフォントは 1 文字が文字サイズの正方形 (12) で、各語が 57 に収まる 4 文字の語にする
      const text = 'Pill done';
      await tester.pumpWidget(subject(text: text));

      expect(tester.takeException(), isNull);
      final paragraph = tester.renderObject<RenderParagraph>(find.text(text));
      expect(paragraph.size.width, lessThanOrEqualTo(columnWidth));
      expect(tester.getRect(find.text(text)).width, paragraph.size.width);
    });
  });
}
