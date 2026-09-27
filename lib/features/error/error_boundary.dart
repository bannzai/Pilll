import 'package:flutter/material.dart';
import 'package:pilll/features/error/page.dart';

/// 子孫の Widget の build で例外が投げられた時のエラー表示を、画面全体用の UniversalErrorPage から [fallback] に差し替える範囲を表す。
/// 一覧の 1 行のように、描画に失敗しても周りの表示を残したい Widget を包む。差し替えは ErrorWidget.builder に設定した [buildErrorWidget] が行う
class ErrorBoundary extends StatelessWidget {
  /// 描画に失敗した Widget の代わりに表示する Widget。
  /// この Widget の build でも例外が投げられると ErrorWidget.builder が繰り返し呼ばれるため、例外を投げない単純な Widget にする
  final Widget fallback;

  /// 描画に失敗した時に [fallback] へ差し替える範囲の Widget
  final Widget child;

  const ErrorBoundary({
    super.key,
    required this.fallback,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// ErrorWidget.builder に設定するエラー表示を作る。
/// 例外を投げた Widget の祖先に [ErrorBoundary] があればその fallback を、無ければ画面全体用の UniversalErrorPage を返す
Widget buildErrorWidget({
  required FlutterErrorDetails details,
  required VoidCallback reload,
}) {
  return Builder(
    builder: (context) =>
        context.findAncestorWidgetOfExactType<ErrorBoundary>()?.fallback ??
        UniversalErrorPage(
          error: details.exception.toString(),
          child: null,
          reload: reload,
        ),
  );
}
