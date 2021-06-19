import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/inquiry/inquiry.dart';
import 'package:flutter/material.dart';

class UniversalErrorPage extends StatefulWidget {
  final dynamic? initialError;
  final Widget? child;
  final VoidCallback? reload;

  const UniversalErrorPage({
    Key? key,
    this.initialError,
    required this.child,
    required this.reload,
  }) : super(key: key);

  static _UniversalErrorPageState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_UniversalErrorPageState>();
    if (state == null) {
      throw AssertionError('''
      Not found UniversalError from this context: $context
      The context should contains UniversalError widget into current widget tree
      ''');
    }
    return state;
  }

  @override
  _UniversalErrorPageState createState() => _UniversalErrorPageState();
}

class _UniversalErrorPageState extends State<UniversalErrorPage> {
  dynamic? _error;

  @override
  void initState() {
    _error = this.widget.initialError;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final child = this.widget.child;
    final error = this._error;
    if (error == null && child != null) {
      return child;
    }
    return Scaffold(
      backgroundColor: PilllColors.background,
      body: Center(
        child: Container(
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
              SizedBox(height: 25),
              Text(error.toString(),
                  style: FontType.assisting.merge(TextColorStyle.main)),
              SizedBox(height: 25),
              TextButton.icon(
                icon: const Icon(
                  Icons.refresh,
                  size: 20,
                ),
                label: Text("画面を再読み込み",
                    style: FontType.assisting.merge(TextColorStyle.black)),
                onPressed: () {
                  analytics.logEvent(name: "reload_button_pressed");
                  setState(() {
                    this._error = null;
                  });
                  final reload = this.widget.reload;
                  if (reload != null) {
                    reload();
                  }
                },
              ),
              TextButton.icon(
                icon: const Icon(
                  Icons.mail,
                  size: 20,
                ),
                label: Text("解決しない場合はこちら",
                    style: FontType.assisting.merge(TextColorStyle.black)),
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

  setError(dynamic error) {
    setState(() {
      this._error = error;
    });
  }
}
