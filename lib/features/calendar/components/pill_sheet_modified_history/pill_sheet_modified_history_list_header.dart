import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/features/localizations/l.dart';

class PillSheetModifiedHisotiryListHeader extends StatelessWidget {
  const PillSheetModifiedHisotiryListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return _HeaderLayout(
      day: Container(width: 64),
      pillNumbersOrHyphen: Container(),
      detail: Text(
        L.takingTime,
        style: const TextStyle(
          color: TextColor.main,
          fontFamily: FontFamily.japanese,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.left,
      ),
      takenPillActionOList: Text(
        L.alreadyTaken,
        style: const TextStyle(
          color: TextColor.main,
          fontFamily: FontFamily.japanese,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Copied from RowLayout
class _HeaderLayout extends StatelessWidget {
  final Widget day;
  final Widget pillNumbersOrHyphen;
  final Widget detail;
  final Widget takenPillActionOList;

  const _HeaderLayout({
    required this.day,
    required this.pillNumbersOrHyphen,
    required this.detail,
    required this.takenPillActionOList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          day,
          const SizedBox(width: 8),
          SizedBox(width: 79, child: pillNumbersOrHyphen),
          const SizedBox(width: 8),
          Expanded(child: detail),
          const SizedBox(width: 8),
          SizedBox(width: 57, child: takenPillActionOList),
        ],
      ),
    );
  }
}
