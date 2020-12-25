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
    return Container(
      width: 295,
      height: 143,
      decoration: BoxDecoration(
        color: this.selected
            ? PilllColors.secondary.withOpacity(0.08)
            : PilllColors.background,
        border: Border.all(
            width: 1,
            color: this.selected ? PilllColors.secondary : PilllColors.disable),
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
                          ? PilllColors.secondary
                          : PilllColors.disable,
                      size: 13),
                  SizedBox(width: 8),
                  Text(this.pillSheetType.name,
                      style: FontType.thinTitle.merge(TextColorStyle.main)),
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
                            style:
                                FontType.assisting.merge(TextColorStyle.main)))
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
