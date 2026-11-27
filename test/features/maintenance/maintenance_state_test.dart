import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pilll/features/maintenance/maintenance_state.dart';

import 'maintenance_state_fixtures.dart';

void main() {
  group('#MaintenanceState.tryParse', () {
    test('5 つの項目がそろった値を読む', () {
      final state = MaintenanceState.tryParse(inMaintenanceWithButton)!;
      expect(state.maintenance, true);
      expect(state.message, '復旧までお待ちください');
      expect(state.button!.label, 'お知らせを見る');
      expect(state.button!.url, Uri.parse('https://example.com/news'));
      expect(state.source, 'owner');
      expect(state.changedAt, '2026-11-25T07:00:00.000Z');
    });

    test('source が owner・cost・usage のどれでもメンテナンス中として読む', () {
      for (final source in ['owner', 'cost', 'usage']) {
        final maintenanceState = MaintenanceState.tryParse(
            {...inMaintenanceWithButton, 'source': source});
        expect(maintenanceState?.maintenance, true, reason: source);
        expect(maintenanceState?.source, source, reason: source);
      }
    });

    test('maintenance・source・changedAt の形が違う値は null を返す', () {
      expect(MaintenanceState.tryParse(null), isNull);
      expect(MaintenanceState.tryParse('maintenance'), isNull);
      expect(
          MaintenanceState.tryParse(
              {...inMaintenanceWithButton, 'maintenance': 'true'}),
          isNull);
      expect(
          MaintenanceState.tryParse(
              {...inMaintenanceWithButton, 'source': 'admin'}),
          isNull);
      expect(
          MaintenanceState.tryParse(
              {...inMaintenanceWithButton, 'changedAt': 1764054000}),
          isNull);
    });

    test('開けない url・空の label の button は、メンテナンス中のまま button だけ null にする', () {
      for (final button in [
        {'label': '開く', 'url': 'javascript:alert(1)'},
        {'label': '開く', 'url': 'example.com/news'},
        {'label': '開く', 'url': 'ftp://example.com/news'},
        {'label': '開く', 'url': 'intent://example.com/news'},
        {'label': '開く', 'url': 'https:news'},
        {'label': '開く', 'url': 'https://[::1'},
        {'label': '開く'},
        {'label': '開く', 'url': 1},
        {'label': '', 'url': 'https://example.com/news'},
        {'url': 'https://example.com/news'},
        'https://example.com/news',
      ]) {
        final state = MaintenanceState.tryParse(
            {...inMaintenanceWithButton, 'button': button})!;
        expect(state.maintenance, true, reason: '$button');
        expect(state.button, isNull, reason: '$button');
      }
    });

    test('空の message と文字列でない message は、メンテナンス中のまま message だけ null にする', () {
      for (final message in ['', 1]) {
        final state = MaintenanceState.tryParse(
            {...inMaintenanceWithButton, 'message': message})!;
        expect(state.maintenance, true, reason: '$message');
        expect(state.message, isNull, reason: '$message');
      }
    });

    test('http の url の button は読む', () {
      expect(
        MaintenanceState.tryParse({
          ...inMaintenanceWithButton,
          'button': {'label': '開く', 'url': 'http://example.com/'},
        })!
            .button!
            .url,
        Uri.parse('http://example.com/'),
      );
    });
  });

  group('#fetchMaintenanceState', () {
    test('200 でメンテナンス中の応答を返した時は、その状態を返す', () async {
      final requestedURLs = <Uri>[];
      final state = await fetchMaintenanceState(
        stateURL,
        client: MockClient((request) async {
          requestedURLs.add(request.url);
          return http.Response.bytes(
              utf8.encode(jsonEncode(inMaintenanceWithButton)), 200);
        }),
      );
      expect(requestedURLs, [stateURL]);
      expect(state.maintenance, true);
      expect(state.message, '復旧までお待ちください');
    });

    test('通信に失敗した時は、メンテナンス中でない状態を返す', () async {
      expect(
        (await fetchMaintenanceState(
          stateURL,
          client: MockClient(
              (_) async => throw http.ClientException('connection failed')),
        ))
            .maintenance,
        false,
      );
    });

    test('200 以外の応答の時は、body がメンテナンス中でもメンテナンス中でない状態を返す', () async {
      expect(
        (await fetchMaintenanceState(
          stateURL,
          client: MockClient((_) async => http.Response.bytes(
              utf8.encode(jsonEncode(inMaintenanceWithButton)), 503)),
        ))
            .maintenance,
        false,
      );
    });

    test('JSON でない応答の時は、メンテナンス中でない状態を返す', () async {
      expect(
        (await fetchMaintenanceState(
          stateURL,
          client: MockClient(
              (_) async => http.Response('<html>maintenance</html>', 200)),
        ))
            .maintenance,
        false,
      );
    });

    test('応答が待つ上限までに返らない時は、メンテナンス中でない状態を返す', () async {
      expect(
        (await fetchMaintenanceState(
          stateURL,
          client: MockClient((_) => Completer<http.Response>().future),
          timeout: const Duration(milliseconds: 10),
        ))
            .maintenance,
        false,
      );
    });

    test('client を渡さない時は、時間切れでも自分で作った client を閉じる', () async {
      final neverRespondingClient = NeverRespondingClient();
      expect(
        (await http.runWithClient(
          () => fetchMaintenanceState(stateURL,
              timeout: const Duration(milliseconds: 10)),
          () => neverRespondingClient,
        ))
            .maintenance,
        false,
      );
      expect(neverRespondingClient.isClosed, true);
    });

    test('client を渡した時は、呼び出し側の client を閉じない', () async {
      final neverRespondingClient = NeverRespondingClient();
      await fetchMaintenanceState(stateURL,
          client: neverRespondingClient,
          timeout: const Duration(milliseconds: 10));
      expect(neverRespondingClient.isClosed, false);
    });
  });
}

/// 応答を返さず、close されたかを記録する HTTP の client
class NeverRespondingClient extends http.BaseClient {
  /// close が呼ばれたか
  bool isClosed = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      Completer<http.StreamedResponse>().future;

  @override
  void close() => isClosed = true;
}
