import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/organisms/pill_mark/pill_mark.dart';
import 'package:flutter/material.dart';
import 'package:pilll/entity/setting.dart';

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
  static int calcPillNumber({
    required int column,
    required int lineIndex,
    required int pageIndex,
    required int pillSheetTotalCount,
  }) {
    return column + 1 + (lineIndex) * 7 + (pageIndex * pillSheetTotalCount);
  }

  static TextStyle upperTextColor({
    required bool isPremium,
    required bool isTrial,
    required PillSheetAppearanceMode pillSheetAppearanceMode,
    required int pillNumberForMenstruationBegin,
    required int menstruationDuration,
    required int maxPillNumber,
    required int pillMarkNumber,
  }) {
    if (!isPremium &&
        !isTrial &&
        pillSheetAppearanceMode != PillSheetAppearanceMode.date) {
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
