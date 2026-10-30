import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/features/feature_appeal/rest_duration/rest_duration_help_page.dart';
import 'package:pilll/features/record/components/pill_sheet/components/rest_duration_explain_image.dart';

void main() {
  group('#RestDurationHelpPage', () {
    testWidgets('見出し・本文の Text Widget が表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: RestDurationHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(Text), findsAtLeast(2));
    });

    testWidgets('PrimaryButton が表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: RestDurationHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('日付表示の説明図を、縦横比を保ったまま幅 80 に縮めて表示する', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: RestDurationHelpPage()),
        ),
      );
      await tester.pump();

      expect(tester.widget<RestDurationExplainImage>(find.byType(RestDurationExplainImage)).appearanceMode, PillSheetAppearanceMode.date);
      // RestDurationExplainImage は 80x80 の枠に入り、図は 221x133 で描いたものを縮めて表示する。画面上の図の大きさは描画範囲 (Stack) の getRect で確かめる
      expect(tester.getSize(find.byType(RestDurationExplainImage)), const Size(80, 80));
      final drawnRect = tester.getRect(find.descendant(of: find.byType(RestDurationExplainImage), matching: find.byType(Stack)).first);
      expect(drawnRect.width, moreOrLessEquals(80));
      expect(drawnRect.height, moreOrLessEquals(80 * 133 / 221));
    });

    testWidgets('AppBar と戻るボタンが表示される', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: RestDurationHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
