import 'package:flutter/material.dart';

class RowLayout extends StatelessWidget {
  final Widget day;
  final Widget effectiveNumbers;
  final Widget time;
  final Widget? takenPillActionOList;

  const RowLayout({
    Key? key,
    required this.day,
    required this.effectiveNumbers,
    required this.time,
    required this.takenPillActionOList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final takenPillActionOList = this.takenPillActionOList;
    return Row(
      children: [
        day,
        SizedBox(width: 8),
        Expanded(
          child: effectiveNumbers,
        ),
        SizedBox(width: 8),
        Expanded(
          child: time,
        ),
        SizedBox(width: 8),
        if (takenPillActionOList != null) ...[
          takenPillActionOList,
        ],
      ],
    );
  }
}
