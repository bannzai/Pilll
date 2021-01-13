import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/domain/root/root.dart';
import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  rootKey.currentState.showIndicator();
}

hideIndicator() {
  rootKey.currentState.hideIndicator();
}
