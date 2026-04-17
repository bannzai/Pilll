import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/features/feature_appeal/alarm_kit/alarm_kit_help_page.dart';
import 'package:pilll/provider/setting.dart';
import 'package:pilll/provider/user.dart';

void main() {
  group('#AlarmKitHelpPage', () {
    List<Override> helpPageProviderOverrides() {
      return [
        userProvider.overrideWith((ref) => Stream.value(const User())),
        settingProvider.overrideWith(
          (ref) => Stream.value(
            const Setting(
              pillNumberForFromMenstruation: 22,
              durationMenstruation: 5,
              isOnReminder: false,
              timezoneDatabaseName: null,
            ),
          ),
        ),
      ];
    }

    testWidgets('見出し・本文の Text Widget が表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AlarmKitHelpPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Text), findsAtLeast(2));
    });

    testWidgets('PrimaryButton が表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AlarmKitHelpPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('AppBar と戻るボタンが表示される', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: helpPageProviderOverrides(),
          child: const MaterialApp(home: AlarmKitHelpPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
