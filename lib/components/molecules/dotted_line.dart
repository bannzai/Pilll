import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';

class DottedLine extends StatelessWidget {
  final double lineLength;
  final double height;
  final double dashLength;
  final double dashGapLength;

  const DottedLine({
    Key? key,
    this.lineLength = double.infinity,
    this.height = 1,
    this.dashLength = 3,
    this.dashGapLength = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dash = _buildDash();
    final dashGap = _buildDashGap();

    return SizedBox(
      width: double.infinity,
      height: 1,
      child: LayoutBuilder(builder: (context, constraints) {
        final dashAndDashGapCount = _calculateDashAndDashGapCount(min(constraints.maxWidth, lineLength));

        return Wrap(
          direction: Axis.horizontal,
          children: List.generate(dashAndDashGapCount, (index) {
            return index % 2 == 0 ? dash : dashGap;
          }).toList(growable: false),
        );
      }),
    );
  }

  int _calculateDashAndDashGapCount(double lineLength) {
    final lengthAndGap = dashLength + dashGapLength;
    var count = lineLength / lengthAndGap * 2;

    if (dashLength <= lineLength % lengthAndGap) {
      count += 1;
    }

    return count.toInt();
  }

  Widget _buildDash() {
    return Container(
      decoration: const BoxDecoration(
        color: PilllColors.primary,
      ),
      width: dashLength,
      height: height,
    );
  }

  Widget _buildDashGap() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      width: dashGapLength,
      height: height,
    );
  }
}
