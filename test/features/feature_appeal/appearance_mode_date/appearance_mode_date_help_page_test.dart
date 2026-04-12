import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/feature_appeal/appearance_mode_date/appearance_mode_date_help_page.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/user.dart';

void main() {
  group('#AppearanceModeDateHelpPage', () {
    List<Override> helpPageProviderOverrides() {
      return [
        userProvider.overrideWith((ref) => Stream.value(const User())),
        latestPillSheetGroupProvider.overrideWith((ref) => Stream<PillSheetGroup?>.value(null)),
      ];
    }

    testWidgets('見出し・本文の Text Widget が表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AppearanceModeDateHelpPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Text), findsAtLeast(2));
    });

    testWidgets('PrimaryButton が表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AppearanceModeDateHelpPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('AppBar と戻るボタンが表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AppearanceModeDateHelpPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
