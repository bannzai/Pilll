import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;

  const AppCard({Key? key, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PilllColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: PilllColors.shadow,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
