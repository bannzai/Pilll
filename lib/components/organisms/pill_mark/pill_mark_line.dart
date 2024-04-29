import 'package:flutter/material.dart';

class PillMarkLine extends StatelessWidget {
  final List<Widget> pillMarks;

  const PillMarkLine({
    super.key,
    required this.pillMarks,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: pillMarks,
    );
  }
}
