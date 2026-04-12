import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/feature_appeal/appearance_mode_date/appearance_mode_date_help_page.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/user.dart';

void main() {
  group('#AppearanceModeDateHelpPage', () {
    /// build 内で watch される `userProvider` / `latestPillSheetGroupProvider` を
    /// Firebase に触れないダミー値で満たすための override。
    List<Override> helpPageProviderOverrides() {
      return [
        userProvider.overrideWith((ref) => Stream.value(const User())),
        latestPillSheetGroupProvider.overrideWith((ref) => Stream<PillSheetGroup?>.value(null)),
      ];
    }

    testWidgets('ヘッドライン文言が表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AppearanceModeDateHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.text(L.appearanceModeDateFeatureAppealHeadline), findsOneWidget);
    });

    testWidgets('本文が表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AppearanceModeDateHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.text(L.appearanceModeDateFeatureAppealBody), findsOneWidget);
    });

    testWidgets('「実際に試す」ボタン (PrimaryButton) が表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AppearanceModeDateHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text(L.featureAppealTryFeature), findsOneWidget);
    });

    testWidgets('AppBar にタイトルが表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AppearanceModeDateHelpPage()),
        ),
      );
      await tester.pump();

      expect(find.text(L.appearanceModeDateFeatureAppealTitle), findsOneWidget);
    });
  });
}
