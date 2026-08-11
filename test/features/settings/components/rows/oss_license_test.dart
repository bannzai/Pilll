import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/features/settings/components/rows/oss_license.dart';
import 'package:pilll/utils/environment.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Environment.isTest = true;
  });

  group('#OSSLicenseRow', () {
    testWidgets('ライセンス一覧を開く行が、端末のロケールに合わせた文言のListTileとして表示される',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('ja'),
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: [Locale('ja'), Locale('en')],
          home: Material(child: OSSLicenseRow()),
        ),
      );

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('ライセンス'), findsOneWidget);
    });

    testWidgets('英語ロケールでは英語の文言で表示される', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: [Locale('ja'), Locale('en')],
          home: Material(child: OSSLicenseRow()),
        ),
      );

      expect(find.text('Licenses'), findsOneWidget);
    });
  });
}
