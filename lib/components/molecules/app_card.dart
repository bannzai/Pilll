import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget? child;

  const AppCard({super.key, this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: PilllColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: PilllColors.shadow,
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
