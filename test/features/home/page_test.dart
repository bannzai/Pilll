import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/home/page.dart';

void main() {
  group('#HomePageTabLabel', () {
    testWidgets('訳の長いラベル (de・es・pt) が 4 等分のタブの幅を超えず 1 行で表示される', (
      WidgetTester tester,
    ) async {
      // 幅の狭い端末 (iPhone SE 第 1 世代相当の 320pt) で確かめる
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      const labels = [
        'Einstellungen',
        'Configuración',
        'Menstruação',
        'Configurações',
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultTabController(
            length: labels.length,
            child: Scaffold(
              bottomNavigationBar: TabBar(
                labelStyle: const TextStyle(fontSize: 12),
                labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                tabs: [
                  for (final label in labels)
                    Tab(
                      icon: const Icon(Icons.circle),
                      child: HomePageTabLabel(text: label),
                    ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      for (final label in labels) {
        // 1 行の上限を超えて切れていない (FittedBox が無いと、タブの幅で切れて true になる)
        expect(
            tester
                .renderObject<RenderParagraph>(find.text(label))
                .didExceedMaxLines,
            isFalse);
        // FittedBox の縮小後の描画幅が、タブ 1 つ分 (320 / 4) から左右の余白 4 を除いた幅に収まる
        expect(
          tester.getRect(find.text(label)).width,
          lessThanOrEqualTo(320 / labels.length - 8),
        );
      }
    });

    testWidgets('幅に収まるラベルは縮小されない', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(width: 72, child: HomePageTabLabel(text: 'Pill')),
            ),
          ),
        ),
      );

      expect(tester.getRect(find.text('Pill')).width,
          tester.renderObject<RenderParagraph>(find.text('Pill')).size.width);
    });
  });
}
