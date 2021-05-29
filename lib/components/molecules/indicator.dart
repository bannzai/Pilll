import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/domain/root/root.dart';
import 'package:flutter/material.dart';
import 'package:pilll/util/environment.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Environment.disableWidgetAnimation) {
      return Container(
        color: PilllColors.primary,
        width: 40,
        height: 40,
      );
    }
    return Container(
      child: Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(PilllColors.primary)),
      ),
    );
  }
}

class ScaffoldIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      body: Indicator(),
    );
  }
}

class DialogIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: PilllColors.modalBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          width: 200,
          height: 200,
          child: Indicator(),
        ),
      ),
    );
  }
}

showIndicator() {
  print("showIndicator -- ");
  rootKey.currentState?.showIndicator();
}

hideIndicator() {
  print("hideIndicator -- ");
  rootKey.currentState?.hideIndicator();
}
