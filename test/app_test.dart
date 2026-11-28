import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pilll/app.dart';
import 'package:pilll/features/maintenance/maintenance_resolver.dart';
import 'package:pilll/l10n/app_localizations.dart';

/// maintenanceResolverBuilder を MaterialApp の builder に置いたアプリを、日本語で組む。
/// [client] は状態の取得の代わりで、通常の画面には「通常の画面」の文を出す
Future<void> pumpApp(WidgetTester tester, {required http.Client client}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('ja'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) =>
          maintenanceResolverBuilder(context, child, client: client),
      home: const Scaffold(body: Text('通常の画面')),
    ),
  );
  await tester.pumpAndSettle();
}

/// 状態を返す Worker の応答の JSON を作る
http.Response stateResponse({required bool maintenance}) {
  return http.Response.bytes(
    utf8.encode(jsonEncode({
      'maintenance': maintenance,
      'message': null,
      'button': null,
      'source': 'owner',
      'changedAt': '2026-11-27T00:00:00.000Z',
    })),
    200,
  );
}

void main() {
  group('#maintenanceResolverBuilder', () {
    testWidgets('本番の Pilll の状態の URL を読み、メンテナンス中は Pilll の既定の文を通常の画面の代わりに出す',
        (tester) async {
      final requestedURLs = <Uri>[];
      await pumpApp(
        tester,
        client: MockClient((request) async {
          requestedURLs.add(request.url);
          return stateResponse(maintenance: true);
        }),
      );

      expect(requestedURLs, [
        Uri.parse('https://service-maintenance.star-kojiki.workers.dev/pilll')
      ]);
      expect(find.text('ただいまメンテナンス中です\nしばらく時間をおいてから\nもう一度お試しください'),
          findsOneWidget);
      expect(find.text('通常の画面'), findsNothing);
    });

    testWidgets('メンテナンス中でない時は通常の画面を出す', (tester) async {
      await pumpApp(tester,
          client: MockClient((_) async => stateResponse(maintenance: false)));

      expect(find.text('通常の画面'), findsOneWidget);
      expect(find.byType(MaintenanceScreen), findsNothing);
    });

    testWidgets('状態を読めない時は通常の画面を出す', (tester) async {
      await pumpApp(tester,
          client: MockClient(
              (_) async => throw http.ClientException('connection failed')));

      expect(find.text('通常の画面'), findsOneWidget);
      expect(find.byType(MaintenanceScreen), findsNothing);
    });
  });
}
