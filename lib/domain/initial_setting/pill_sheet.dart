import 'package:Pilll/components/atoms/color.dart';
import 'package:Pilll/entity/pill_sheet_type.dart';
import 'package:Pilll/components/atoms/font.dart';
import 'package:Pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';

class PillSheet extends StatelessWidget {
  final PillSheetType pillSheetType;
  final bool selected;
  const PillSheet({
    Key key,
    @required this.pillSheetType,
    @required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Container(
        width: 146,
        height: 129,
        decoration: BoxDecoration(
          color: this.selected
              ? PilllColors.secondary.withOpacity(0.08)
              : PilllColors.background,
          border: Border.all(
              width: 1,
              color:
                  this.selected ? PilllColors.secondary : PilllColors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 20),
                Text("${this.pillSheetType.dosingPeriod}錠",
                    style: FontType.thinTitle.merge(TextColorStyle.main)),
                SizedBox(height: 10),
                this.pillSheetType.image,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
