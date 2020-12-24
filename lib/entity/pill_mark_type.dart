import 'package:Pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum PillMarkType {
  normal,
  fake,
  rest,
  selected,
  done,
}

extension PillMarkTypeFunctions on PillMarkType {
  static SvgPicture _checkImage() {
    return SvgPicture.asset(
      "images/checkmark.svg",
      color: PilllColors.potti,
      width: 11,
      height: 8.5,
    );
  }

  static Widget create(bool isDone, PillMarkType type) {
    return Container(
      width: 20,
      height: 20,
      child: Center(
        child: () {
          switch (type) {
            case PillMarkType.normal:
              return null;
            case PillMarkType.rest:
              return isDone ? _checkImage() : null;
            case PillMarkType.fake:
              return isDone ? _checkImage() : null;
            case PillMarkType.selected:
              return null;
            case PillMarkType.done:
              return isDone ? _checkImage() : null;
            default:
              assert(false);
              return null;
          }
        }(),
      ),
      decoration: BoxDecoration(
        color: () {
          switch (type) {
            case PillMarkType.normal:
              return PilllColors.potti;
            case PillMarkType.rest:
              return PilllColors.blank;
            case PillMarkType.fake:
              return PilllColors.blank;
            case PillMarkType.selected:
              return PilllColors.enable;
            case PillMarkType.done:
              return PilllColors.lightGray;
            default:
              assert(false);
              return null;
          }
        }(),
        shape: BoxShape.circle,
      ),
    );
  }
}
