import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';

class PillSheetModifiedHisotiryListHeader extends StatelessWidget {
  const PillSheetModifiedHisotiryListHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _HeaderLayout(
      day: Container(width: 64),
      effectiveNumbersOrHyphen: Container(),
      detail: Text(
        "服用時間",
        style: TextStyle(
          color: TextColor.main,
          fontFamily: FontFamily.japanese,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.left,
      ),
      takenPillActionOList: Text(
        "服用済み",
        style: TextStyle(
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
  final Widget effectiveNumbersOrHyphen;
  final Widget detail;
  final Widget takenPillActionOList;

  const _HeaderLayout({
    Key? key,
    required this.day,
    required this.effectiveNumbersOrHyphen,
    required this.detail,
    required this.takenPillActionOList,
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
            width: 0.5,
          ),
          SizedBox(width: 8),
          Container(
            width: 79,
            child: effectiveNumbersOrHyphen,
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
