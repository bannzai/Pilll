import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/record/components/pill_sheet/components/rest_duration_explain_image.dart';

/// 吹き出しの Text が、画面上で SVG の吹き出しの矩形 (viewBox 221x133 の x: 43.8〜147.8, y: 91〜133) の中に収まっていることを確かめる。
/// 図が縮んで描かれた時も、図の描画範囲 (Stack) からの縮尺で矩形を求めて比べる
void expectTextInsideBalloon(WidgetTester tester) {
  final drawnRect = tester.getRect(find.descendant(of: find.byType(RestDurationExplainImage), matching: find.byType(Stack)).first);
  final scale = drawnRect.width / 221;
  final textRect = tester.getRect(find.byType(Text));
  expect(textRect.left, greaterThanOrEqualTo(drawnRect.left + 43.8 * scale - 0.01));
  expect(textRect.right, lessThanOrEqualTo(drawnRect.left + 147.8 * scale + 0.01));
  expect(textRect.top, greaterThanOrEqualTo(drawnRect.top + 91 * scale - 0.01));
  expect(textRect.bottom, lessThanOrEqualTo(drawnRect.top + 133 * scale + 0.01));
}

void main() {
  group('#RestDurationExplainImage', () {
    group('表示する図', () {
      testWidgets('番号表示の場合は番号の図を表示する', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Center(child: RestDurationExplainImage(appearanceMode: PillSheetAppearanceMode.number)),
          ),
        );

        expect(
          (tester.widget<SvgPicture>(find.byType(SvgPicture)).bytesLoader as SvgAssetLoader).assetName,
          'images/explain_rest_duration_number.svg',
        );
      });

      testWidgets('日付表示の場合は日付の図を表示する', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Center(child: RestDurationExplainImage(appearanceMode: PillSheetAppearanceMode.date)),
          ),
        );

        expect((tester.widget<SvgPicture>(find.byType(SvgPicture)).bytesLoader as SvgAssetLoader).assetName, 'images/explain_rest_duration_date.svg');
      });

      testWidgets('連番表示の場合は番号の図を表示する', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Center(child: RestDurationExplainImage(appearanceMode: PillSheetAppearanceMode.sequential)),
          ),
        );

        expect(
          (tester.widget<SvgPicture>(find.byType(SvgPicture)).bytesLoader as SvgAssetLoader).assetName,
          'images/explain_rest_duration_number.svg',
        );
      });

      testWidgets('周期的連番表示の場合は番号の図を表示する', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Center(child: RestDurationExplainImage(appearanceMode: PillSheetAppearanceMode.cyclicSequential)),
          ),
        );

        expect(
          (tester.widget<SvgPicture>(find.byType(SvgPicture)).bytesLoader as SvgAssetLoader).assetName,
          'images/explain_rest_duration_number.svg',
        );
      });
    });

    group('吹き出しの文言', () {
      testWidgets('図の吹き出しの位置に Text を重ねる', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Center(child: RestDurationExplainImage(appearanceMode: PillSheetAppearanceMode.number)),
          ),
        );

        expect(find.descendant(of: find.byType(Positioned), matching: find.byType(Text)), findsOneWidget);
        expectTextInsideBalloon(tester);
      });

      testWidgets('端末の文字サイズを拡大しても吹き出しからはみ出さない', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(3)),
              child: Center(child: RestDurationExplainImage(appearanceMode: PillSheetAppearanceMode.date)),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expectTextInsideBalloon(tester);
      });

      // 320pt 幅の端末のダイアログでは、本文の幅が約 192 になる (AlertDialog の左右の余白 40 と contentPadding 24)
      testWidgets('幅が 221 より狭い時は、文字も図と一緒に縮んで吹き出しの中に収まる', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Center(
              child: SizedBox(width: 192, child: RestDurationExplainImage(appearanceMode: PillSheetAppearanceMode.number)),
            ),
          ),
        );

        expect(
          tester.getRect(find.descendant(of: find.byType(RestDurationExplainImage), matching: find.byType(Stack)).first).width,
          moreOrLessEquals(192),
        );
        expectTextInsideBalloon(tester);
      });
    });

    testWidgets('幅に余裕がある時は SVG の viewBox と同じ 221x133 で描く', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(child: RestDurationExplainImage(appearanceMode: PillSheetAppearanceMode.number)),
        ),
      );

      expect(tester.getSize(find.byType(RestDurationExplainImage)), const Size(221, 133));
    });
  });
}
