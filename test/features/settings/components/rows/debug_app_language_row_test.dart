import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/localizations/l.dart';
import 'package:pilll/features/settings/components/rows/debug_app_language_row.dart';
import 'package:pilll/l10n/app_localizations.dart';
import 'package:pilll/utils/environment.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Environment.isTest = true;
  });

  tearDown(() {
    L = lookupAppLocalizations(const Locale('ja'));
  });

  group('#DebugAppLanguageRow', () {
    testWidgets(
      '文言の言語が zh の時は zh の Semantics identifier を持ち、隣の vi の identifier を持たない',
      (WidgetTester tester) async {
        L = lookupAppLocalizations(const Locale('zh'));
        await tester.pumpWidget(
          const MaterialApp(home: Material(child: DebugAppLanguageRow())),
        );

        expect(
          find.bySemanticsIdentifier('debug_app_language_current_zh'),
          findsOneWidget,
        );
        expect(
          find.bySemanticsIdentifier('debug_app_language_current_vi'),
          findsNothing,
        );
      },
    );

    testWidgets(
      '文言の言語が vi の時は vi の Semantics identifier を持ち、zh の identifier を持たない',
      (WidgetTester tester) async {
        L = lookupAppLocalizations(const Locale('vi'));
        await tester.pumpWidget(
          const MaterialApp(home: Material(child: DebugAppLanguageRow())),
        );

        expect(
          find.bySemanticsIdentifier('debug_app_language_current_vi'),
          findsOneWidget,
        );
        expect(
          find.bySemanticsIdentifier('debug_app_language_current_zh'),
          findsNothing,
        );
      },
    );
  });
}
