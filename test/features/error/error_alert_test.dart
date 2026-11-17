import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/error/error_alert.dart';

void main() {
  group('#ErrorAlert', () {
    testWidgets('本文が画面の高さより長い時、本文は切り詰められずスクロールできる高さで配置される', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final errorMessage = List.generate(
        80,
        (index) => '${index + 1}行目の案内',
      ).join('\n');

      await tester.pumpWidget(
        MaterialApp(
          home: ErrorAlert(
            errorMessage: errorMessage,
            faqLinkURL: 'https://example.com',
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      // スクロールできない時は、本文の高さが画面の高さ以下に切り詰められる
      expect(tester.getSize(find.text(errorMessage)).height, greaterThan(480));
    });

    testWidgets('本文が画面の高さより長い時、続きがあることが分かるようにスクロールバーが常に出る設定で、本文と同じスクロール位置を使う', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 480);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: ErrorAlert(
            errorMessage: List.generate(
              80,
              (index) => '${index + 1}行目の案内',
            ).join('\n'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        tester.widget<Scrollbar>(find.byType(Scrollbar)).thumbVisibility,
        isTrue,
      );
      // Scrollbar は route の PrimaryScrollController を使うため、本文も同じ controller で動いていることを確かめる
      expect(
        PrimaryScrollController.of(
          tester.element(find.byType(Scrollbar)),
        ).position.maxScrollExtent,
        greaterThan(0),
      );
    });

    for (final textDirection in TextDirection.values) {
      testWidgets(
          '文字方向が $textDirection の時、スクロールバーが出る側 (文字方向の終わり側) にだけ本文の余白 12 を取る',
          (WidgetTester tester) async {
        tester.view.physicalSize = const Size(320, 480);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: textDirection,
              child: ErrorAlert(
                errorMessage: List.generate(
                  80,
                  (index) => '${index + 1}行目の案内',
                ).join('\n'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        switch (textDirection) {
          case TextDirection.ltr:
            expect(
              tester
                      .getRect(
                        find.descendant(
                          of: find.byType(SingleChildScrollView),
                          matching: find.byType(Text),
                        ),
                      )
                      .left -
                  tester.getRect(find.byType(SingleChildScrollView)).left,
              0,
            );
            expect(
              tester.getRect(find.byType(SingleChildScrollView)).right -
                  tester
                      .getRect(
                        find.descendant(
                          of: find.byType(SingleChildScrollView),
                          matching: find.byType(Text),
                        ),
                      )
                      .right,
              12,
            );
          case TextDirection.rtl:
            expect(
              tester
                      .getRect(
                        find.descendant(
                          of: find.byType(SingleChildScrollView),
                          matching: find.byType(Text),
                        ),
                      )
                      .left -
                  tester.getRect(find.byType(SingleChildScrollView)).left,
              12,
            );
            expect(
              tester.getRect(find.byType(SingleChildScrollView)).right -
                  tester
                      .getRect(
                        find.descendant(
                          of: find.byType(SingleChildScrollView),
                          matching: find.byType(Text),
                        ),
                      )
                      .right,
              0,
            );
        }
      });
    }

    testWidgets('本文が短い時、本文が表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ErrorAlert(errorMessage: '短いエラー')),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('短いエラー'), findsOneWidget);
    });
  });
}
