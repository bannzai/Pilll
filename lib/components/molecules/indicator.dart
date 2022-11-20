import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/util/environment.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Environment.disableWidgetAnimation) {
      return Center(
        child: Container(
          color: PilllColors.secondary,
          width: 40,
          height: 40,
        ),
      );
    }
    return const Center(
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(PilllColors.secondary)),
    );
  }
}

class ScaffoldIndicator extends StatelessWidget {
  const ScaffoldIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: PilllColors.background,
      body: Indicator(),
    );
  }
}

class DialogIndicator extends StatelessWidget {
  const DialogIndicator({Key? key}) : super(key: key);

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
          child: const Indicator(),
        ),
      ),
    );
  }
}
