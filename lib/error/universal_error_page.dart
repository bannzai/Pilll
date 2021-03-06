import 'package:Pilll/analytics.dart';
import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:Pilll/domain/root/root.dart';
import 'package:Pilll/inquiry/inquiry.dart';
import 'package:flutter/material.dart';

class UniversalErrorPage extends StatelessWidget {
  final Error error;
  final Widget child;

  const UniversalErrorPage({Key key, @required this.error, this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (this.error == null && this.child != null) {
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
              FlatButton.icon(
                textColor: PilllColors.primary,
                icon: const Icon(
                  Icons.refresh,
                  size: 20,
                ),
                label: Text("画面を再読み込み", style: FontType.assisting),
                onPressed: () {
                  analytics.logEvent(name: "reload_button_pressed");
                  rootKey.currentState.reloadRoot();
                },
              ),
              FlatButton.icon(
                textColor: PilllColors.secondary,
                icon: const Icon(
                  Icons.mail,
                  size: 20,
                ),
                label: Text("解決しない場合はこちら", style: FontType.assisting),
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
