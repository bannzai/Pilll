import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/record/components/pill_sheet/components/rest_duration_explain_image.dart';

void main() {
  group('#RestDurationExplainImage', () {
    group('表示する図', () {
      testWidgets('番号表示の場合は番号の図を表示する', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Center(child: RestDurationExplainImage(appearanceMode: PillSheetAppearanceMode.number)),
          ),
        );

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect((svgPicture.bytesLoader as SvgAssetLoader).assetName, 'images/explain_rest_duration_number.svg');
      });

      testWidgets('日付表示の場合は日付の図を表示する', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Center(child: RestDurationExplainImage(appearanceMode: PillSheetAppearanceMode.date)),
          ),
        );

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect((svgPicture.bytesLoader as SvgAssetLoader).assetName, 'images/explain_rest_duration_date.svg');
      });

      testWidgets('連番表示の場合は番号の図を表示する', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Center(child: RestDurationExplainImage(appearanceMode: PillSheetAppearanceMode.sequential)),
          ),
        );

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect((svgPicture.bytesLoader as SvgAssetLoader).assetName, 'images/explain_rest_duration_number.svg');
      });

      testWidgets('周期的連番表示の場合は番号の図を表示する', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Center(child: RestDurationExplainImage(appearanceMode: PillSheetAppearanceMode.cyclicSequential)),
          ),
        );

        final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
        expect((svgPicture.bytesLoader as SvgAssetLoader).assetName, 'images/explain_rest_duration_number.svg');
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
        // 吹き出しの矩形は SVG の viewBox (221x133) の x: 43.8〜147.8, y: 91〜133
        final imageTopLeft = tester.getTopLeft(find.byType(RestDurationExplainImage));
        final textRect = tester.getRect(find.byType(Text));
        expect(textRect.left - imageTopLeft.dx, greaterThanOrEqualTo(43.8));
        expect(textRect.right - imageTopLeft.dx, lessThanOrEqualTo(147.8));
        expect(textRect.top - imageTopLeft.dy, greaterThanOrEqualTo(91));
        expect(textRect.bottom - imageTopLeft.dy, lessThanOrEqualTo(133));
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
        final imageTopLeft = tester.getTopLeft(find.byType(RestDurationExplainImage));
        final textRect = tester.getRect(find.byType(Text));
        expect(textRect.left - imageTopLeft.dx, greaterThanOrEqualTo(43.8));
        expect(textRect.right - imageTopLeft.dx, lessThanOrEqualTo(147.8));
        expect(textRect.top - imageTopLeft.dy, greaterThanOrEqualTo(91));
        expect(textRect.bottom - imageTopLeft.dy, lessThanOrEqualTo(133));
      });
    });

    testWidgets('大きさは SVG の viewBox と同じ 221x133', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(child: RestDurationExplainImage(appearanceMode: PillSheetAppearanceMode.number)),
        ),
      );

      expect(tester.getSize(find.byType(RestDurationExplainImage)), const Size(221, 133));
    });
  });
}
