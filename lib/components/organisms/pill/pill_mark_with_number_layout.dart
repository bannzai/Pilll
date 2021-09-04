import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/organisms/pill/pill_mark.dart';
import 'package:flutter/material.dart';

class PillMarkWithNumberLayout extends StatelessWidget {
  final Text textOfPillNumber;
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
  static int calcPillNumber({required int column, required int row}) {
    return column + 1 + (row) * 7;
  }

  static TextStyle upperTextColor({
    required bool isPremium,
    required int pillNumberForMenstruationBegin,
    required int menstruationDuration,
    required int maxPillNumber,
    required int pillMarkNumber,
  }) {
    if (!isPremium) {
      return TextStyle(color: PilllColors.weekday);
    }
    final begin = pillNumberForMenstruationBegin;
    final duration = menstruationDuration;
    final menstruationNumbers = List.generate(duration, (index) {
      final number = (begin + index) % maxPillNumber;
      return number == 0 ? maxPillNumber : number;
    });
    return menstruationNumbers.contains(pillMarkNumber)
        ? TextStyle(color: PilllColors.primary)
        : TextStyle(color: PilllColors.weekday);
  }
}
