import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum CalendarHelpPageRow {
  menstruation,
  nextPillSheet,
  recordExists,
  sex,
  hospital
}

extension CalendarHelpPageRowFunctions on CalendarHelpPageRow {
  SvgPicture icon() {
    switch (this) {
      case CalendarHelpPageRow.menstruation:
        return SvgPicture.asset(
          "images/rectangle.svg",
          color: PilllColors.menstruation,
        );
      case CalendarHelpPageRow.nextPillSheet:
        return SvgPicture.asset(
          "images/rectangle.svg",
          color: PilllColors.duration,
        );
      case CalendarHelpPageRow.recordExists:
        return SvgPicture.asset(
          "images/oval.svg",
        );
      case CalendarHelpPageRow.sex:
        return SvgPicture.asset(
          "images/heart.svg",
        );
      case CalendarHelpPageRow.hospital:
        return SvgPicture.asset(
          "images/hospital.svg",
        );
      default:
        assert(false);
        return null;
    }
  }

  Widget title() {
    switch (this) {
      case CalendarHelpPageRow.menstruation:
        return Text(
          "生理期間",
          style: FontType.row.merge(TextColorStyle.lightGray2),
        );
      case CalendarHelpPageRow.nextPillSheet:
        return Text(
          "新しいシート開始",
          style: FontType.row.merge(TextColorStyle.lightGray2),
        );
      case CalendarHelpPageRow.recordExists:
        return Text(
          "新しいシート開始",
          style: FontType.row.merge(TextColorStyle.lightGray2),
        );
      case CalendarHelpPageRow.sex:
        return Text(
          "SEX",
          style: FontType.row.merge(TextColorStyle.lightGray2),
        );
      case CalendarHelpPageRow.hospital:
        return Text(
          "来院予定日",
          style: FontType.row.merge(TextColorStyle.lightGray2),
        );
      default:
        assert(false);
        return null;
    }
  }
}

class CalendarHelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: PilllColors.modalBackground,
        body: Center(
          child: Container(
            width: 280,
            height: 267,
            child: Card(
              child: Row(
                children: <Widget>[
                  SizedBox(width: 16),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 16),
                      Text(
                        "アイコンの説明",
                        style: FontType.subTitle.merge(TextColorStyle.black),
                      ),
                      ...CalendarHelpPageRow.values.map((e) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ConstrainedBox(
                              constraints: BoxConstraints.expand(
                                width: 40,
                                height: 12,
                              ),
                              child: Center(
                                child: e.icon(),
                              ),
                            ),
                            SizedBox(width: 16),
                            e.title(),
                          ],
                        );
                      }),
                      SizedBox(height: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
