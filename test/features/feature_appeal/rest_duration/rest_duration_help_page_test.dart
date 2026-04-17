import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/features/feature_appeal/rest_duration/rest_duration_help_page.dart';

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
