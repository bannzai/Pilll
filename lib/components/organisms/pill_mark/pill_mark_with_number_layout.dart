import 'package:pilll/components/organisms/pill_mark/pill_mark.dart';
import 'package:flutter/material.dart';

class PillMarkWithNumberLayout extends StatelessWidget {
  final Widget pillNumber;
  final PillMark pillMark;
  final VoidCallback onTap;

  /// タップを無効にするかどうか
  /// trueの場合、onTapは呼び出されない
  final bool isDisabled;

  const PillMarkWithNumberLayout({
    super.key,
    required this.pillMark,
    required this.pillNumber,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : () => onTap(),
      child: Column(
        children: <Widget>[
          pillNumber,
          pillMark,
        ],
      ),
    );
  }
}

extension PillMarkWithNumberLayoutHelper on PillMarkWithNumberLayout {
  static int calcPillNumberIntoPillSheet(int columnIndex, int lineIndex) {
    return columnIndex + 1 + (lineIndex) * 7;
  }
}
