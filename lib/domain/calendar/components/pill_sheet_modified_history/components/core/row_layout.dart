import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';

class RowLayout extends StatelessWidget {
  final Widget day;
  final Widget effectiveNumbers;
  final Widget detail;
  final Widget? takenPillActionOList;

  const RowLayout({
    Key? key,
    required this.day,
    required this.effectiveNumbers,
    required this.detail,
    this.takenPillActionOList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final takenPillActionOList = this.takenPillActionOList;
    return Container(
      padding: EdgeInsets.only(left: 4),
      child: Row(
        children: [
          day,
          SizedBox(width: 8),
          Container(
            height: 26,
            child: VerticalDivider(
              color: PilllColors.divider,
              width: 0.5,
            ),
          ),
          SizedBox(width: 8),
          Container(
            width: 79,
            child: effectiveNumbers,
          ),
          SizedBox(width: 8),
          Expanded(
            child: detail,
          ),
          if (takenPillActionOList != null) ...[
            SizedBox(width: 8),
            Container(
              width: 57,
              child: takenPillActionOList,
            ),
          ],
        ],
      ),
    );
  }
}
