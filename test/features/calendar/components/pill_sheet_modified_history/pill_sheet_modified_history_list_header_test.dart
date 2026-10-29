import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_list_header.dart';

void main() {
  group('#PillSheetModifiedHistoryListHeaderWrappedLabel', () {
    // 服用履歴の「服用済み」列と同じ幅
    const columnWidth = 57.0;
    const style = TextStyle(fontSize: 12);

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
        final lines = paragraph.computeLineMetrics();
        expect(lines.length, 2);
        // 2 行目が「eingenommen」1 語だけで、語の途中で折り返していない
        final secondLineStart =
            paragraph.getPositionForOffset(Offset(0, lines[1].baseline)).offset;
        expect(text.substring(secondLineStart).trim(), 'eingenommen');
        expect(
          tester.getRect(find.text(text)).width,
          lessThanOrEqualTo(columnWidth),
        );
      },
    );

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
