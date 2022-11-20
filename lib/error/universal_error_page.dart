import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/settings/components/inquiry/inquiry.dart';
import 'package:flutter/material.dart';

class _InheritedWidget extends InheritedWidget {
  const _InheritedWidget({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(key: key, child: child);

  final _UniversalErrorPageState state;

  @override
  bool updateShouldNotify(covariant _InheritedWidget oldWidget) {
    return false;
  }
}

class UniversalErrorPage extends StatefulWidget {
  final Object? error;
  final Widget? child;
  final VoidCallback? reload;

  const UniversalErrorPage({
    Key? key,
    required this.error,
    required this.child,
    required this.reload,
  }) : super(key: key);

  @override
  _UniversalErrorPageState createState() => _UniversalErrorPageState();
}

class _UniversalErrorPageState extends State<UniversalErrorPage> {
  Object? _error;
  showError(Object error) {
    setState(() {
      _error = error;
    });
  }

  Object? get error => _error ?? widget.error;

  @override
  Widget build(BuildContext context) {
    final child = widget.child;
    final error = this.error;
    return _InheritedWidget(
      state: this,
      child: () {
        if (error != null) return _errorPage(error);
        if (child != null) return child;
        throw AssertionError("unexpected child and error are both null");
      }(),
    );
  }

  Widget _errorPage(Object error) {
    final String message;
    if (error is FormatException) {
      message = error.message;
    } else {
      message = error.toString();
    }
    return Scaffold(
      backgroundColor: PilllColors.background,
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "images/universal_error.png",
                width: 200,
                height: 190,
              ),
              const SizedBox(height: 25),
              Text(message,
                  style: const TextStyle(
                    fontFamily: FontFamily.japanese,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ).merge(TextColorStyle.main)),
              const SizedBox(height: 25),
              TextButton.icon(
                icon: const Icon(
                  Icons.refresh,
                  size: 20,
                ),
                label: Text("画面を再読み込み",
                    style: const TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ).merge(TextColorStyle.black)),
                onPressed: () {
                  analytics.logEvent(name: "reload_button_pressed");
                  setState(() {
                    _error = null;
                    final reload = widget.reload;
                    if (reload != null) {
                      reload();
                    }
                  });
                },
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.mail,
                  size: 20,
                ),
                label: Text("解決しない場合はこちら",
                    style: const TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                    ).merge(TextColorStyle.black)),
                onPressed: () {
                  analytics.logEvent(name: "problem_unresolved_button_pressed");
                  inquiry();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
