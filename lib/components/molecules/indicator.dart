import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';
import 'package:pilll/utils/environment.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (Environment.disableWidgetAnimation) {
      return Center(
        child: Container(
          color: AppColors.secondary,
          width: 40,
          height: 40,
        ),
      );
    }
    return const Center(
      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(AppColors.secondary)),
    );
  }
}

class ScaffoldIndicator extends StatelessWidget {
  const ScaffoldIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Indicator(),
    );
  }
}

class DialogIndicator extends StatelessWidget {
  const DialogIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.modalBackground,
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
