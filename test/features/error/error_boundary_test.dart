import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/error/error_boundary.dart';
import 'package:pilll/features/error/page.dart';

/// build で必ず例外を投げる Widget。描画に失敗した Widget の代わり
class _ThrowingWidget extends StatelessWidget {
  const _ThrowingWidget();

  @override
  Widget build(BuildContext context) {
    throw Exception('build failed');
  }
}

void main() {
  group('#buildErrorWidget', () {
    testWidgets(
        '例外を投げた Widget の祖先に ErrorBoundary がある場合、ErrorBoundary の fallback が表示される',
        (tester) async {
      final originalErrorWidgetBuilder = ErrorWidget.builder;
      // テスト環境では ForceUpdate が ErrorWidget.builder を設定しないため、本番と同じ builder をこのテストの間だけ設定する。
      // flutter_test はテストの終了時に ErrorWidget.builder が元に戻っていることを検査するため、テストの本体の中で戻す
      ErrorWidget.builder =
          (details) => buildErrorWidget(details: details, reload: () {});
      try {
        await tester.pumpWidget(
          const MaterialApp(
            home: Material(
              child: Column(
                children: [
                  ErrorBoundary(
                    fallback: SizedBox(key: ValueKey('fallback')),
                    child: _ThrowingWidget(),
                  ),
                ],
              ),
            ),
          ),
        );

        // build の例外は FlutterError に報告されたうえで ErrorWidget.builder の表示に差し替わる
        expect(tester.takeException(), isNotNull);
        expect(find.byKey(const ValueKey('fallback')), findsOneWidget);
        expect(find.byType(UniversalErrorPage), findsNothing);
      } finally {
        ErrorWidget.builder = originalErrorWidgetBuilder;
      }
    });

    testWidgets(
        '例外を投げた Widget の祖先に ErrorBoundary が無い場合、UniversalErrorPage が表示される',
        (tester) async {
      final originalErrorWidgetBuilder = ErrorWidget.builder;
      // テスト環境では ForceUpdate が ErrorWidget.builder を設定しないため、本番と同じ builder をこのテストの間だけ設定する。
      // flutter_test はテストの終了時に ErrorWidget.builder が元に戻っていることを検査するため、テストの本体の中で戻す
      ErrorWidget.builder =
          (details) => buildErrorWidget(details: details, reload: () {});
      try {
        await tester.pumpWidget(
          const MaterialApp(home: _ThrowingWidget()),
        );

        expect(tester.takeException(), isNotNull);
        expect(find.byType(UniversalErrorPage), findsOneWidget);
      } finally {
        ErrorWidget.builder = originalErrorWidgetBuilder;
      }
    });
  });
}
