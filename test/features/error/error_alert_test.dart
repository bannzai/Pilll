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

    testWidgets('本文が短い時、本文が表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ErrorAlert(errorMessage: '短いエラー')),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('短いエラー'), findsOneWidget);
    });
  });
}
