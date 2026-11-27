import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/maintenance/maintenance_state.dart';

/// クライアントが状態を読み直す間隔の既定。
/// 切り替えてから開いたままの画面が変わるまでの遅れを、deploy の反映の遅れに 60 秒を足した時間までにする
/// (service-maintenance-setup skill の SKILL.md「読む間隔と待つ上限」)
const defaultMaintenancePollInterval = Duration(seconds: 60);

/// アプリの一番外側に置き、メンテナンス中の間だけ [child] の代わりにメンテナンス中の画面を出す。
/// 起動時・前面に戻った時・前面にいる間の [pollInterval] ごとに状態を読む。
/// `MaterialApp(builder: (context, child) => MaintenanceGate(..., child: child!))` の形で置く
class MaintenanceGate extends StatefulWidget {
  /// 読む先と、状態に無い時の文、ボタンの開き方、通常の画面から作る
  const MaintenanceGate({
    super.key,
    required this.stateURL,
    required this.defaultMessage,
    required this.onOpenURL,
    required this.child,
    this.pollInterval = defaultMaintenancePollInterval,
    this.client,
  });

  /// `<状態を返す Worker の URL>/<サービス名>`
  final Uri stateURL;

  /// 状態の message が null の時に出す、このサービスの既定の文
  final String defaultMessage;

  /// ボタンが押された時に URL を開く処理 (url_launcher の `launchUrl` 等)
  final void Function(Uri url) onOpenURL;

  /// メンテナンス中でない時に出す通常の画面
  final Widget child;

  /// 状態を読み直す間隔
  final Duration pollInterval;

  /// 状態の取得に使う HTTP のクライアント。テストで差し替える
  final http.Client? client;

  @override
  State<MaintenanceGate> createState() => _MaintenanceGateState();
}

/// [MaintenanceGate] が読んだ状態と、読み直しのタイマーを持つ
class _MaintenanceGateState extends State<MaintenanceGate> with WidgetsBindingObserver {
  /// 最後に読んだ状態。読む前と読めなかった時はメンテナンス中でない状態
  MaintenanceState _maintenanceState = MaintenanceState.notInMaintenance;

  /// [MaintenanceGate.pollInterval] ごとに読み直すタイマー
  Timer? _pollTimer;

  /// 始めた読み取りの通し番号。後から始めた読み取りが先に返った時に、古い結果で画面を戻さないために使う
  int _latestReadNumber = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 背面で作られた時 (バックグラウンドでの起動等) は、状態が変わるまで didChangeAppLifecycleState が呼ばれないため、
    // ここで今の状態を見る。背面ならタイマーは後の resumed の通知で作る
    if (const {null, AppLifecycleState.resumed, AppLifecycleState.inactive}.contains(WidgetsBinding.instance.lifecycleState)) {
      _startPolling();
    }
    _read();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    super.dispose();
  }

  /// 前面にいる間だけ読み直すタイマーを動かす (背面でも Dart の isolate が動き続けるプラットフォームがあるため、
  /// タイマーを止めないと背面の間も読む。読む回数の見積もりは前面にいた分数で数えている。SKILL.md「読む回数と費用の見積もり」)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _startPolling();
        _read();
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _pollTimer?.cancel();
        _pollTimer = null;
      case AppLifecycleState.inactive:
        break;
    }
  }

  /// [MaintenanceGate.pollInterval] ごとに読み直すタイマーを、動いていなければ作る
  void _startPolling() {
    _pollTimer ??= Timer.periodic(widget.pollInterval, (_) => _read());
  }

  /// 状態を読み、最後に始めた読み取りの結果だけを画面に反映する
  Future<void> _read() async {
    final readNumber = ++_latestReadNumber;
    final maintenanceState = await fetchMaintenanceState(widget.stateURL, client: widget.client);
    if (!mounted || readNumber != _latestReadNumber) return;
    setState(() => _maintenanceState = maintenanceState);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 通常の画面は外さずに隠す (メンテナンスが終わった時に、利用者がいた画面へ戻すため)。
        // 隠している間はフォーカス (キーボードの入力) とアニメーションも止める (Offstage はタップと描画だけを外すため)
        Offstage(
          offstage: _maintenanceState.maintenance,
          child: ExcludeFocus(
            excluding: _maintenanceState.maintenance,
            child: TickerMode(enabled: !_maintenanceState.maintenance, child: widget.child),
          ),
        ),
        if (_maintenanceState.maintenance)
          MaintenanceScreen(
            message: _maintenanceState.message ?? widget.defaultMessage,
            button: _maintenanceState.button,
            onOpenURL: widget.onOpenURL,
          ),
      ],
    );
  }
}

/// メンテナンス中の画面。[button] が null の時はボタンを出さない
class MaintenanceScreen extends StatelessWidget {
  /// 出す文と、ボタン、ボタンの開き方から作る
  const MaintenanceScreen({super.key, required this.message, required this.button, required this.onOpenURL});

  /// 利用者に見せる文
  final String message;

  /// 画面に出すボタン。null ならボタンを出さない
  final MaintenanceButton? button;

  /// ボタンが押された時に URL を開く処理
  final void Function(Uri url) onOpenURL;

  @override
  Widget build(BuildContext context) {
    final button = this.button;
    return Material(
      color: AppColors.background,
      child: SafeArea(
        child: Center(
          child: Padding(
            // 余白 (24) は Material の画面の端の余白として一般的な 24 にした
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  // 文字の大きさと太さは、Pilll の画面の本文 (例: 服用お休みの説明) と同じ 16・w400 にそろえた
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: TextColor.main,
                  ),
                ),
                if (button != null) ...[
                  // 文とボタンの間も、画面の端の余白と同じ 24 にそろえた
                  const SizedBox(height: 24),
                  PrimaryButton(onPressed: () async => onOpenURL(button.url), text: button.label),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
