import 'dart:convert';

import 'package:http/http.dart' as http;

/// メンテナンス中の画面に出すボタン
class MaintenanceButton {
  /// ボタンの文と遷移先からボタンを作る
  const MaintenanceButton({required this.label, required this.url});

  /// ボタンに出す文
  final String label;

  /// ボタンを押した時に開く URL (http・https だけ)
  final Uri url;

  /// JSON から読んだ値のうち、ボタンとして使えるものだけを返す。形が違う・開けない URL の時は null (ボタンを出さない)
  static MaintenanceButton? tryParse(Object? json) {
    if (json is! Map) return null;
    final label = json['label'];
    final url = json['url'];
    if (label is! String || label.isEmpty || url is! String) return null;
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasAuthority || !const {'http', 'https'}.contains(uri.scheme)) return null;
    return MaintenanceButton(label: label, url: uri);
  }
}

/// 1 つのサービスが、いまメンテナンス中かどうか (状態を返す Worker の `GET /<サービス名>` の応答)
class MaintenanceState {
  /// 応答の 5 つの項目から状態を作る
  const MaintenanceState({
    required this.maintenance,
    required this.message,
    required this.button,
    required this.source,
    required this.changedAt,
  });

  /// true の間、クライアントはメンテナンス中の画面を出す
  final bool maintenance;

  /// 利用者に見せる文。null ならサービス側の既定の文
  final String? message;

  /// メンテナンス中の画面に出すボタン。null ならボタンを出さない
  final MaintenanceButton? button;

  /// 何が切り替えたか ("owner"・"cost"・"usage")
  final String source;

  /// 最後に切り替わった時刻 (ISO 8601)
  final String changedAt;

  /// 状態が 1 度も書かれていない時と、状態を読めなかった時に使う「メンテナンス中でない」状態
  static const notInMaintenance = MaintenanceState(
    maintenance: false,
    message: null,
    button: null,
    // 通常に戻せるのは owner のコマンドだけのため、メンテナンス中でない状態の切り替え元は owner になる
    source: 'owner',
    // 1 度も切り替わっていないことを、型 (ISO 8601 の文字列) を変えずに表せる値として UNIX 時刻の起点を使う
    changedAt: '1970-01-01T00:00:00.000Z',
  );

  /// JSON から読んだ値を状態として読む。maintenance・source・changedAt の形が違う時は null を返す。
  /// message と button は、形が違っても状態全体を捨てず null にする (メンテナンス中の切り替えそのものを落とさないため)
  static MaintenanceState? tryParse(Object? json) {
    if (json is! Map) return null;
    final maintenance = json['maintenance'];
    final message = json['message'];
    final source = json['source'];
    final changedAt = json['changedAt'];
    if (maintenance is! bool || changedAt is! String) return null;
    if (source is! String || !const {'owner', 'cost', 'usage'}.contains(source)) return null;
    return MaintenanceState(
      maintenance: maintenance,
      message: message is String && message.isNotEmpty ? message : null,
      button: MaintenanceButton.tryParse(json['button']),
      source: source,
      changedAt: changedAt,
    );
  }
}

/// stateURL (`<状態を返す Worker の URL>/<サービス名>`) から状態を読む。
/// 読めなかった時 (通信の失敗・時間切れ・200 以外・形の違う応答) は [MaintenanceState.notInMaintenance] を返し、例外を投げない
/// (状態の置き場の障害で、読む側のサービスを止めないため)
Future<MaintenanceState> fetchMaintenanceState(
  Uri stateURL, {
  http.Client? client,
  // 状態を返す Worker が応答しない時に、読み取りが終わるまでの時間を 2 秒までにする
  // (service-maintenance-setup skill の SKILL.md「読む間隔と待つ上限」)
  Duration timeout = const Duration(seconds: 2),
}) async {
  // client を渡されなかった時は自分で作り、時間切れの時も閉じる (timeout は待つのをやめるだけで、通信を止めないため)。
  // 渡された client は渡した側が使い続けるため閉じない
  http.Client? ownedClient;
  try {
    ownedClient = client == null ? http.Client() : null;
    final response = await (client ?? ownedClient!).get(stateURL).timeout(timeout);
    if (response.statusCode != 200) return MaintenanceState.notInMaintenance;
    return MaintenanceState.tryParse(jsonDecode(utf8.decode(response.bodyBytes))) ?? MaintenanceState.notInMaintenance;
  } catch (_) {
    return MaintenanceState.notInMaintenance;
  } finally {
    ownedClient?.close();
  }
}
