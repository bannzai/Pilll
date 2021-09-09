import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';

abstract class PillSheetTypeColumnConstant {
  static final double width = 146;
  static final double height = 140;
  static double get aspectRatio => width / height;
}

class PillSheetTypeColumn extends StatelessWidget {
  final PillSheetType pillSheetType;
  final bool selected;
  const PillSheetTypeColumn({
    Key? key,
    required this.pillSheetType,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 146, minHeight: 129),
      decoration: BoxDecoration(
        color: this.selected
            ? PilllColors.secondary.withOpacity(0.08)
            : PilllColors.white,
        border: Border.all(
          width: this.selected ? 2 : 1,
          color: this.selected ? PilllColors.secondary : PilllColors.border,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          top: 10,
          right: 25,
          bottom: PillSheetType.pillsheet_21_0 == pillSheetType ? 30 : 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("${_title(pillSheetType)}",
                style: FontType.thinTitle.merge(TextColorStyle.main)),
            SizedBox(height: 2),
            Text("${_subtitle(pillSheetType)}",
                style: FontType.assisting.merge(TextColorStyle.main)),
            SizedBox(height: 9),
            this.pillSheetType.image,
          ],
        ),
      ),
    );
  }

  String _title(PillSheetType pillSheetType) {
    switch (pillSheetType) {
      case PillSheetType.pillsheet_21:
        return "21錠";
      case PillSheetType.pillsheet_28_4:
        return "28錠";
      case PillSheetType.pillsheet_28_7:
        return "28錠";
      case PillSheetType.pillsheet_28_0:
        return "28錠";
      case PillSheetType.pillsheet_24_0:
        return "24錠";
      case PillSheetType.pillsheet_21_0:
        return "21錠";
    }
  }

  String _subtitle(PillSheetType pillSheetType) {
    switch (pillSheetType) {
      case PillSheetType.pillsheet_21:
        return "21錠＋7日休薬";
      case PillSheetType.pillsheet_28_4:
        return "24錠＋4錠偽薬";
      case PillSheetType.pillsheet_28_7:
        return "21錠＋7錠偽薬";
      case PillSheetType.pillsheet_28_0:
        return "すべて実薬";
      case PillSheetType.pillsheet_24_0:
        return "すべて実薬";
      case PillSheetType.pillsheet_21_0:
        return "すべて実薬";
    }
  }
}
