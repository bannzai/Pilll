import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';

class DotsIndicator extends AnimatedWidget {
  const DotsIndicator({
    super.key,
    required this.controller,
    required this.itemCount,
    required this.onDotTapped,
  }) : super(listenable: controller);

  final PageController controller;
  final int itemCount;
  final ValueChanged<int> onDotTapped;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, _buildDot),
    );
  }

  Widget _buildDot(int index) {
    final isSelected = index == (controller.page ?? controller.initialPage).round();
    return SizedBox(
      width: 25,
      child: Center(
        child: Material(
          color: isSelected ? PilllColors.primary : PilllColors.unselect,
          type: MaterialType.circle,
          child: SizedBox(
            width: 8,
            height: 8,
            child: InkWell(
              onTap: () => onDotTapped(index),
            ),
          ),
        ),
      ),
    );
  }
}
