import 'package:Pilll/theme/color.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:flutter/material.dart';

class PillSheet extends StatelessWidget {
  final PillSheetType pillSheetType;
  final bool selected;
  const PillSheet({
    Key key,
    this.pillSheetType,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 295,
      height: 143,
      decoration: BoxDecoration(
        color: this.selected ? PilllColors.selected : PilllColors.background,
        border: Border.all(
            width: 1,
            color: this.selected ? PilllColors.enable : PilllColors.disable),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.check,
                      color: this.selected
                          ? PilllColors.enable
                          : PilllColors.disable,
                      size: 13),
                  SizedBox(width: 8),
                  Text(this.pillSheetType.name,
                      style: FontType.thinTitle.merge(TextColorStyle.gray)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  this.pillSheetType.image,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: this
                        .pillSheetType
                        .examples
                        .map((e) => Text("$e",
                            style: FontType.description
                                .merge(TextColorStyle.black)))
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
