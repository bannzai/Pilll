import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/root/root.dart';
import 'package:pilll/inquiry/inquiry.dart';
import 'package:flutter/material.dart';

class UniversalErrorPage extends StatelessWidget {
  final String? error;
  final Widget child;
  final VoidCallback reload;

  const UniversalErrorPage({
    Key? key,
    required this.error,
    required this.child,
    required this.reload,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (error == null) {
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
                  rootKey.currentState?.reloadRoot();
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
}
