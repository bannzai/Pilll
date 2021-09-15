import 'package:pilll/components/organisms/pill_mark/pill_mark.dart';
import 'package:flutter/material.dart';

class PillMarkWithNumberLayout extends StatelessWidget {
  final Widget textOfPillNumber;
  final PillMark pillMark;
  final VoidCallback onTap;

  const PillMarkWithNumberLayout({
    Key? key,
    required this.pillMark,
    required this.textOfPillNumber,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        children: <Widget>[
          textOfPillNumber,
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
