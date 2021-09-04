import 'package:flutter/material.dart';

class PillMarkLine extends StatelessWidget {
  final List<Widget> pillMarks;

  const PillMarkLine({
    Key? key,
    required this.pillMarks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: pillMarks,
    );
  }
}
