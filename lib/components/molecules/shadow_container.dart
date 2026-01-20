import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Widget child;

  const ShadowContainer({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
